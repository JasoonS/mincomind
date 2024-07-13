// SPDX-License-Identifier: BSD-3-Clause-Clear

pragma solidity ^0.8.19;

import "fhevm/lib/TFHE.sol";
import "fhevm/abstracts/Reencrypt.sol";

contract MincoMind is Reencrypt {
    constructor() Reencrypt() {}

    struct Game {
        euint8[4] secret;
        uint8[4][8] guesses;
        uint64 lastGuesTimestamp; // Prevent revealing guess in same timestamp as guess.
        uint8 numGuesses;
        bool isComplete;
        uint32 timeStarted;
    }

    struct Clue {
        uint8 bulls;
        uint8 cows;
    }

    mapping(address => mapping(uint32 => Game)) games;
    mapping(address => uint32) latestGames;

    function generateSecret() private view returns (euint8[4] memory) {
        euint8[4] memory secret;
        for (uint i = 0; i < secret.length; i++) {
            secret[i] = TFHE.randEuint8();
        }

        return secret;
    }

    function newGame() public {
        uint32 latestGame = ++latestGames[msg.sender];
        uint8[4][8] memory guesses;
        games[msg.sender][latestGame] = Game({
            secret: generateSecret(),
            guesses: guesses,
            lastGuesTimestamp: 0,
            numGuesses: 0,
            isComplete: false,
            timeStarted: uint32(block.timestamp)
        });
    }

    function checkGuessResult(address player, uint32 gameId, uint guessIndex) public view returns (Clue memory) {
        Game memory game = games[player][gameId];
        uint8[4] memory guess = game.guesses[guessIndex];
        require(game.lastGuesTimestamp < uint64(block.timestamp), "Can't view result in same block as guess");
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
        Game memory game = games[msg.sender][latestGames[msg.sender]];
        require(game.numGuesses < 8, "Too many guesses");
        require(!game.isComplete, "Game is already complete");
        game.guesses[game.numGuesses] = guess;

        game.numGuesses += 1;
        game.lastGuesTimestamp = uint64(block.timestamp);

        games[msg.sender][latestGames[msg.sender]] = game;

        /// emit event or log of the guess
    }
}
