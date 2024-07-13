// SPDX-License-Identifier: BSD-3-Clause-Clear

pragma solidity 0.8.22;

import "../Mincomind.sol";

import "hardhat/console.sol";

contract MincomindTester is Mincomind {
    constructor() Mincomind() {}

    function initializeGameWithValues(uint8 first, uint8 second, uint8 third, uint8 fourth) public payable {
        console.log("Deploy values", msg.value, DEPOSIT_AMOUNT);
        if (msg.value == 0) {
            revert("Value cannot be zero");
        } else if (msg.value < DEPOSIT_AMOUNT) {
            revert("Deposit too low");
        } else if (msg.value > DEPOSIT_AMOUNT) {
            revert("Deposit too high");
        }
        require(msg.value == DEPOSIT_AMOUNT, "You must deposit exactly 0.001 inco tokens");

        euint8[4] memory secret;
        secret[0] = TFHE.asEuint8(first);
        secret[1] = TFHE.asEuint8(second);
        secret[2] = TFHE.asEuint8(third);
        secret[3] = TFHE.asEuint8(fourth);

        uint32 latestGame = ++latestGames[msg.sender];
        uint8[4][8] memory guesses;
        games[msg.sender][latestGame] = Game({
            secret: secret,
            guesses: guesses,
            lastGuessTimestamp: 0,
            numGuesses: 0,
            isComplete: false,
            timeStarted: uint32(block.timestamp)
        });

        // lockedFunds += DEPOSIT_AMOUNT;
    }

    function viewSecret(address player, uint32 gameId) public view returns (uint8[4] memory) {
        Game memory game = games[player][gameId];
        uint8[4] memory decryptedSecret;
        for (uint i = 0; i < 4; i++) {
            decryptedSecret[i] = TFHE.decrypt(game.secret[i]);
        }
        return decryptedSecret;
    }

    function viewGuesses(address player, uint32 gameId) public view returns (uint8[4][8] memory) {
        Game memory game = games[player][gameId];
        return game.guesses;
    }

    function viewGuessResult(address player, uint32 gameId, uint guessIndex) public view returns (Clue memory) {
        return checkGuessResult(player, gameId, guessIndex);
    }

    function viewGameDetails(address player, uint32 gameId) public view returns (Game memory) {
        return games[player][gameId];
    }

    function viewPlayerPoints(address player) public view returns (uint32) {
        return points[player];
    }
}
