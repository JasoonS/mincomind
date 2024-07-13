// SPDX-License-Identifier: BSD-3-Clause-Clear

pragma solidity 0.8.22;

import "fhevm/lib/TFHE.sol";
import "fhevm/abstracts/Reencrypt.sol";
import "hardhat/console.sol";

contract Mincomind is Reencrypt {
    constructor() Reencrypt() {}

    struct Game {
        euint8[4] secret;
        uint8[4][8] guesses;
        uint64 lastGuessTimestamp; // Prevent revealing guess in same timestamp as guess.
        uint8 numGuesses;
        bool isComplete;
        uint32 timeStarted;
    }

    struct Clue {
        uint8 bulls;
        uint8 cows;
    }

    // user => gameId => Game
    mapping(address => mapping(uint32 => Game)) games;

    // user => latestGameId
    mapping(address => uint32) latestGames;

    // user => points
    mapping(address => uint32) public points;

    uint32 public totalPoints = 0;

    // amount of funds in contract still locked in an active game
    uint256 public lockedFunds = 0;

    // anyone can end the game after 10 minutes to transfer the deposit to the pot
    uint16 public constant MAX_SECONDS_PER_GAME = 600; // 10 minutes
    uint256 public constant DEPOSIT_AMOUNT = 1000000000000000; // 0.001 ether; // 1_000_000_000_000_000 wei

    event NewGame(address indexed player, uint32 gameId);
    event GuessAdded(address indexed player, uint32 gameId, uint8 numGuesses, uint8[4] guess);
    event GameOutcome(address indexed player, uint32 gameId, uint8 points);
    event FundsWithdrawn(address player, uint256 amount);

    function generateSecret() private view returns (euint8[4] memory) {
        euint8[4] memory secret;
        for (uint i = 0; i < secret.length; i++) {
            // We take modulo 6 to make sure we only have 6 possible values.
            secret[i] = TFHE.rem(TFHE.randEuint8(), 6);
        }
        return secret;
    }

    function newGame() public payable {
        // console.log("Deploy values", msg.value, DEPOSIT_AMOUNT);
        require(msg.value == DEPOSIT_AMOUNT, "You must deposit exactly 0.001 inco tokens");
        if (games[msg.sender][latestGames[msg.sender]].timeStarted > 0) {
            require(
                games[msg.sender][latestGames[msg.sender]].isComplete,
                "Can't start new game before completing current game"
            );
        }
        // require(
        //     games[msg.sender][latestGames[msg.sender]].isComplete,
        //     "Can't start new game before completing current game"
        // );
        uint32 latestGame = ++latestGames[msg.sender];
        uint8[4][8] memory guesses;
        games[msg.sender][latestGame] = Game({
            secret: generateSecret(),
            guesses: guesses,
            lastGuessTimestamp: 0,
            numGuesses: 0,
            isComplete: false,
            timeStarted: uint32(block.timestamp)
        });
        lockedFunds += DEPOSIT_AMOUNT;
        emit NewGame(msg.sender, latestGame);
    }

    function checkGuessResult(address player, uint32 gameId, uint guessIndex) public view returns (Clue memory) {
        Game memory game = games[player][gameId];
        uint8[4] memory guess = game.guesses[guessIndex];
        require(game.lastGuessTimestamp < uint64(block.timestamp), "Can't view result in same block as guess");
        require(guessIndex < 8, "index too high");

        return compareArrays(game.secret, guess);
    }

    function compareArrays(euint8[4] memory secret, uint8[4] memory guess) internal view returns (Clue memory) {
        ebool[4] memory used;
        euint8 bulls;
        for (uint i = 0; i < secret.length; i++) {
            ebool isBull = TFHE.eq(secret[i], TFHE.asEuint8(guess[i]));
            bulls = bulls + TFHE.cmux(isBull, TFHE.asEuint8(1), TFHE.asEuint8(0));
            used[i] = isBull;
        }

        euint8 cows;
        for (uint i = 0; i < secret.length; i++) {
            ebool isCow = TFHE.asEbool(false);
            for (uint j = 0; j < secret.length; j++) {
                ebool isCowFromCurrentCheck = TFHE.and(
                    TFHE.and(TFHE.and(TFHE.not(used[i]), TFHE.not(used[j])), TFHE.not(isCow)),
                    TFHE.eq(secret[j], TFHE.asEuint8(guess[i]))
                );
                used[j] = TFHE.or(used[j], isCowFromCurrentCheck);
                isCow = TFHE.or(isCow, isCowFromCurrentCheck);
            }
            cows = cows + TFHE.cmux(isCow, TFHE.asEuint8(1), TFHE.asEuint8(0));
        }

        return Clue({ bulls: TFHE.decrypt(bulls), cows: TFHE.decrypt(cows) });
    }

    function addGuess(uint8[4] memory guess) public {
        Game storage game = games[msg.sender][latestGames[msg.sender]];
        require(game.numGuesses < 8, "Too many guesses");
        require(!game.isComplete, "Game is already complete");
        game.guesses[game.numGuesses] = guess;
        game.numGuesses += 1;
        game.lastGuessTimestamp = uint64(block.timestamp);

        emit GuessAdded(msg.sender, latestGames[msg.sender], game.numGuesses, guess);
    }

    function endGame(address user) public {
        Game storage game = games[user][latestGames[user]];
        require(!game.isComplete, "Game is already ended");
        Clue memory clue = checkGuessResult(user, latestGames[user], game.numGuesses - 1);

        // if the user has not guessed the secret in 10 minutes, the game can be ended by anyone
        require(block.timestamp - game.timeStarted > MAX_SECONDS_PER_GAME || clue.bulls == 4, "Game is not yet ended");
        uint8 gamePoints = clue.bulls == 4 ? 9 - game.numGuesses : 0;
        points[user] += gamePoints;
        totalPoints += gamePoints;

        game.isComplete = true;

        lockedFunds -= DEPOSIT_AMOUNT;

        // todo: add secret reveal

        emit GameOutcome(msg.sender, latestGames[msg.sender], gamePoints);
    }

    function withdrawFunds() public {
        uint32 userPoints = points[msg.sender];

        uint256 pot = address(this).balance - lockedFunds;

        uint256 amount = (((userPoints * 10e18) / totalPoints) * pot) / 10e18;

        // uint256 precision = 1; /// I don't think precission is needed please test me! Can add more later.

        // uint256 amount = (pot * userPoints * precision) / (totalPoints * precision);

        // set points to 0 for user
        totalPoints -= userPoints;
        points[msg.sender] = 0;

        // transfer funds to user
        payable(msg.sender).transfer(amount);

        emit FundsWithdrawn(msg.sender, amount);
    }
}
