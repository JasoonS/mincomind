// SPDX-License-Identifier: BSD-3-Clause-Clear

pragma solidity 0.8.22;

import "fhevm/lib/TFHE.sol";
import "fhevm/abstracts/Reencrypt.sol";
import "hardhat/console.sol";

contract Mincomind is Reencrypt {
    constructor() payable Reencrypt() {
        require(msg.value == DEPOSIT_AMOUNT, "Initial liquidity must be exactly 0.001 ether");

        totalPoints = 1;

        lockedFunds = DEPOSIT_AMOUNT;
    }

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
    mapping(address => mapping(uint32 => Game)) public games;

    // user => latestGameId
    mapping(address => uint32) public latestGames;

    // user => points
    mapping(address => uint32) public points;

    // user => latestgameWasWon (1 = won 0 = not won)
    mapping(address => euint8) public latestGameWasWon;

    uint32 public totalPoints;

    // amount of funds in contract still locked in an active game
    uint256 public lockedFunds;

    // anyone can end the game after 10 minutes to transfer the deposit to the pot
    uint16 public constant MAX_SECONDS_PER_GAME = 3600; // 1 hour 

    uint256 public constant DEPOSIT_AMOUNT = 1000000000000000; // 0.001 ether; // 1_000_000_000_000_000 wei

    event NewGame(address indexed player, uint32 indexed gameId);
    event GuessAdded(
        address indexed player,
        uint32 indexed gameId,
        uint8 indexed numGuesses,
        uint8[4] guess,
        uint8 bulls,
        uint8 cows
    );
    event GameOutcome(address indexed player, uint32 indexed gameId, uint8 points);
    event FundsWithdrawn(address indexed player, uint256 amount);

    function generateSecret() private view returns (euint8[4] memory) {
        euint8[4] memory secret;
        for (uint i = 0; i < secret.length; i++) {
            // We take modulo 6 to make sure we only have 6 possible values.
            secret[i] = TFHE.rem(TFHE.randEuint8(), 6);
        }
        return secret;
    }

    function newGame() public payable {
        require(msg.value == DEPOSIT_AMOUNT, "You must deposit exactly 0.001 inco tokens");
        if (games[msg.sender][latestGames[msg.sender]].timeStarted > 0) {
            require(
                games[msg.sender][latestGames[msg.sender]].isComplete,
                "Can't start new game before completing current game"
            );
        }

        latestGameWasWon[msg.sender] = TFHE.asEuint8(0);

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

    // todo: revert to being private
    function checkUserHasWon(address user, uint64 lastGuessTimestamp) private view returns (bool) {        
        require(block.timestamp > lastGuessTimestamp, "can't determine whether won in the same block");  
        return TFHE.decrypt(latestGameWasWon[user]) == 1;        
    }

    function compareArrays(euint8[4] memory secret, uint8[4] memory guess) internal view returns (Clue memory) {
        ebool[4] memory usedByBulls;
        euint8 bulls;
        for (uint i = 0; i < secret.length; i++) {
            ebool isBull = TFHE.eq(secret[i], TFHE.asEuint8(guess[i]));
            bulls = bulls + TFHE.cmux(isBull, TFHE.asEuint8(1), TFHE.asEuint8(0));
            usedByBulls[i] = isBull;
        }

        euint8 cows;
        // We need to keep the used array for bulls separate from cows
        ebool[4] memory used;
        for (uint i = 0; i < secret.length; i++) {
            used[i] = usedByBulls[i]; // need to make a copy and no longer mutate usedByBulls
        }

        for (uint i = 0; i < secret.length; i++) {
            ebool isCow = TFHE.asEbool(false);
            for (uint j = 0; j < secret.length; j++) {
                ebool isCowFromCurrentCheck = TFHE.and(
                    TFHE.and(TFHE.and(TFHE.not(usedByBulls[i]), TFHE.not(used[j])), TFHE.not(isCow)),
                    TFHE.eq(secret[j], TFHE.asEuint8(guess[i]))
                );
                used[j] = TFHE.or(used[j], isCowFromCurrentCheck);
                isCow = TFHE.or(isCow, isCowFromCurrentCheck);
            }
            cows = cows + TFHE.cmux(isCow, TFHE.asEuint8(1), TFHE.asEuint8(0));
        }

        return Clue({ bulls: TFHE.decrypt(bulls), cows: TFHE.decrypt(cows) });
    }

    // todo: add a check to make sure a new game has been started
    function addGuess(uint8[4] memory guess) public {
        Game storage game = games[msg.sender][latestGames[msg.sender]];
        require(game.numGuesses < 8, "Too many guesses");
        require(!game.isComplete, "Game is already complete");
        game.guesses[game.numGuesses] = guess;
        game.numGuesses += 1;
        game.lastGuessTimestamp = uint64(block.timestamp);

        // NOTE the below line is only used for indexing - the smart contract get the return value to prevent manipulation (and reverting)
        //      it isn't needed for the game to operate correctly, and uses more gas.
        //      Before going to 'mainnet' this contract should check and make sure miner manipulation cannot allow miners to exploit this contract.
        Clue memory guessHint = compareArrays(game.secret, guess);

        if (guessHint.bulls == 4) {
            latestGameWasWon[msg.sender] = TFHE.asEuint8(1);
        }

        emit GuessAdded(msg.sender, latestGames[msg.sender], game.numGuesses, guess, guessHint.bulls, guessHint.cows);
    }

    function endGame(address user) public {
        Game storage game = games[user][latestGames[user]];
        require(!game.isComplete, "Game is already ended");        

        bool hasWon = checkUserHasWon(user, game.lastGuessTimestamp);                

        // if the user has not guessed the secret in 1 hour, the game can be ended by anyone
        require(block.timestamp - game.timeStarted > MAX_SECONDS_PER_GAME || hasWon, "Game is not yet ended or user has not won");
        uint8 gamePoints = hasWon ? 9 - game.numGuesses : 0;
        points[user] += gamePoints;
        totalPoints += gamePoints;

        game.isComplete = true;

        lockedFunds -= DEPOSIT_AMOUNT;

        emit GameOutcome(msg.sender, latestGames[msg.sender], gamePoints);
    }

    function withdrawFunds() public {
        uint32 userPoints = points[msg.sender];

        uint256 pot = address(this).balance - lockedFunds;

        uint256 amount = (pot * userPoints) / totalPoints;


        // set points to 0 for user
        totalPoints -= userPoints;
        points[msg.sender] = 0;

        // transfer funds to user
        payable(msg.sender).transfer(amount);

        emit FundsWithdrawn(msg.sender, amount);
    }

    function getLatestGameId(address user) public view returns (uint32) {
        return latestGames[user];
    }

    function getGame(address user, uint32 gameId) public view returns (Game memory) {
        return games[user][gameId];
    }
}
