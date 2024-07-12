// SPDX-License-Identifier: BSD-3-Clause-Clear

pragma solidity ^0.8.20;

import "fhevm/lib/TFHE.sol";
import "fhevm/abstracts/EIP712WithModifier.sol";

contract MincoMind is EIP712WithModifier {
    constructor() EIP712WithModifier("Authorization token", "1") {}

    struct Game {
        euint8[4] secret;
        uint8[4][8] guesses;
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
            numGuesses: 0,
            isComplete: false,
            timeStarted: uint32(block.timestamp)
        });
    }

    function addGuess(uint8[4] memory guess) public returns (bool) {
        Game storage game = games[msg.sender][latestGames[msg.sender]];
        require(game.numGuesses < 8, "Too many guesses");
        require(!game.isComplete, "Game is already complete");

        Clue memory clue;

// euint8[4]
//         euint8 bulls;
//         euint8 cows;
//         for (uint i = 0; i < game.secret.length; i++) {
//             euint8 numBulls = TFHE.add(
//                 bulls,
//                 TFHE.cmux(TFHE.eq(game.secret[i], TFHE.asEuint8(guess[i])), TFHE.asEuint8(1), TFHE.asEuint8(0))
//             );
// TFHE.ne(numBulls,)
//
//             bulls += numBulls;
//
//isBull = secret slot = currentSlot
//isCow = if !isBull {
//iterate through array and look for first match
}


        }
    }
}
