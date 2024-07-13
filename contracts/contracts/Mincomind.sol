// SPDX-License-Identifier: BSD-3-Clause-Clear

pragma solidity ^0.8.19;

import "fhevm/lib/TFHE.sol";
import "fhevm/abstracts/Reencrypt.sol";

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

    // anyone can end the game after 10 minutes to transfer the deposit to the pot
    uint16 constant MAX_SECONDS_PER_GAME = 600; // 10 minutes

    event NewGame(address indexed player, uint32 gameId);
    event GuessAdded(address indexed player, uint32 gameId, uint8[4] guess);
    event GameOutcome(address indexed player, uint32 gameId, uint8 points);

    function generateSecret() private view returns (euint8[4] memory) {
        euint8[4] memory secret;
        for (uint i = 0; i < secret.length; i++) {
            // We bit shift it 5 places to make sure we only have 8 possible values.
            secret[i] = TFHE.shr(TFHE.randEuint8(), TFHE.asEuint8(5));
        }
        return secret;
    }

    function newGame() public {
        require(games[msg.sender][latestGames[msg.sender]].isComplete, "Can't start new game before completing current game");
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
        emit NewGame(msg.sender, latestGame);
    }

    function checkGuessResult(address player, uint32 gameId, uint guessIndex) public view returns (Clue memory) {
        Game memory game = games[player][gameId];
        uint8[4] memory guess = game.guesses[guessIndex];
        require(game.lastGuessTimestamp < uint64(block.timestamp), "Can't view result in same block as guess");
        require(guessIndex < 8, "index too high");

        ebool[4] memory used;
        euint8 bulls;
        for (uint i = 0; i < game.secret.length; i++) {
            ebool isBull = TFHE.eq(game.secret[i], TFHE.asEuint8(guess[i]));
            bulls = bulls + TFHE.cmux(isBull, TFHE.asEuint8(1), TFHE.asEuint8(0));
            used[i] = isBull;
        }

        euint8 cows;
        for (uint i = 0; i < game.secret.length; i++) {
            ebool isCow = TFHE.asEbool(false);
            for (uint j = 0; j < game.secret.length; j++) {
                ebool isCowFromCurrentCheck = TFHE.and(
                    TFHE.and(TFHE.and(TFHE.not(used[i]), TFHE.not(used[j])), TFHE.not(isCow)),
                    TFHE.ne(game.secret[j], TFHE.asEuint8(guess[i]))
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

        emit GuessAdded(msg.sender, latestGames[msg.sender], guess);
    }

    function endGame(address memory user) public {        
        Game storage game = games[user][latestGames[user]];
        require(!game.isComplete, "Game is already ended");
        Clue memory clue = checkGuessResult(user, latestGames[user], game.numGuesses - 1);
        
        // if the user has not guessed the secret in 10 minutes, the game can be ended by anyone
        require(block.timestamp - game.timeStarted > MAX_SECONDS_PER_GAME || clue.bulls == 4, "Game is not yet ended");
        uint8 memory points = clue.bulls == 4 ? 9 - game.numGuesses : 0;
        points[user] += points;
        require(clue.bulls == 4, "Guess is not correct");

        game.isComplete = true;

        emit GameOutcome(msg.sender, latestGames[msg.sender], points);
    }
}
