// SPDX-License-Identifier: BSD-3-Clause-Clear

pragma solidity 0.8.22;

import "../Mincomind.sol";

import "hardhat/console.sol";

contract FakeFHE {
    ////////////////////
    /// Faked algorithm for debugging
    ////////////////////

    function compareArraysDebug(uint8[4] memory secret, uint8[4] memory guess) public pure returns (uint8, uint8) {
        bool[4] memory usedByBulls;
        uint8 bulls;
        for (uint i = 0; i < secret.length; i++) {
            bool isBull = fAKEeq(secret[i], fAKEasEuint8(guess[i]));
            bulls += fAKEcmux(isBull, 1, 0);
            usedByBulls[i] = isBull;
        }

        uint8 cows;
        // We need to keep the used array for bulls separate from cows
        bool[4] memory used;
        for (uint i = 0; i < secret.length; i++) {
            used[i] = usedByBulls[i]; // need to make a copy and no longer mutate usedByBulls
        }

        for (uint i = 0; i < secret.length; i++) {
            bool isCow = false;
            for (uint j = 0; j < secret.length; j++) {
                console.log("guess: %s = %s (%s)", i, guess[i], used[i]);
                console.log("secret: %s = %s (%s)", j, secret[j], used[j]);
                console.log("");

                bool isCowFromCurrentCheck = fAKEand(
                    fAKEand(fAKEnot(usedByBulls[i]), fAKEnot(used[j])),
                    fAKEnot(isCow) && fAKEeq(secret[j], fAKEasEuint8(guess[i]))
                );

                if (isCowFromCurrentCheck) {
                    console.log("!!!\n!!!\n\nisCowFromCurrentCheck: %s \n\n!!!\n!!!\n", isCowFromCurrentCheck);
                }

                used[j] = fAKEor(used[j], isCowFromCurrentCheck);
                isCow = fAKEor(isCow, isCowFromCurrentCheck);

                console.log("updated used[j]: %s", used[j]);
                console.log("updated isCow: %s", isCow);
                console.log("\n---------\n");
            }
            cows += fAKEcmux(isCow, 1, 0);
            console.log("cows after iteration %s: %s", i, cows);
        }

        // return Clue({ bulls: fAKEdecrypt(bulls), cows: fAKEdecrypt(cows) });
        return (bulls, cows);
    }

    // Fake versions of the TFHE functions
    function fAKEcmux(bool condition, uint8 trueVal, uint8 falseVal) private pure returns (uint8) {
        return condition ? trueVal : falseVal;
    }

    function fAKEasEuint8(uint8 value) private pure returns (uint8) {
        return value;
    }

    function fAKEeq(uint8 a, uint8 b) private pure returns (bool) {
        return a == b;
    }

    function fAKEand(bool a, bool b) private pure returns (bool) {
        return a && b;
    }

    function fAKEnot(bool a) private pure returns (bool) {
        return !a;
    }

    function fAKEor(bool a, bool b) private pure returns (bool) {
        return a || b;
    }

    function fAKEdecrypt(uint8 value) public pure returns (uint8) {
        return value;
    }
}
contract MincomindTester is Mincomind, FakeFHE {
    constructor() payable Mincomind() {}

    function initializeGameWithValues(uint8 first, uint8 second, uint8 third, uint8 fourth) public payable {
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

        lockedFunds += DEPOSIT_AMOUNT;

        emit NewGame(msg.sender, latestGame);
    }

    function updateValuesForPlayer(address user, uint8 first, uint8 second, uint8 third, uint8 fourth) public {
        Game storage usersGame = games[user][latestGames[user]];

        require(usersGame.numGuesses == 0, "Game already started");
        require(usersGame.timeStarted >= block.timestamp - 10 minutes, "past expiry time");
        require(!usersGame.isComplete, "game completed");

        usersGame.secret[0] = TFHE.asEuint8(first);
        usersGame.secret[1] = TFHE.asEuint8(second);
        usersGame.secret[2] = TFHE.asEuint8(third);
        usersGame.secret[3] = TFHE.asEuint8(fourth);
    }

    function checkGuessedResultHacked(
        address player,
        uint32 gameId,
        uint8[4] calldata guess
    ) public view returns (Clue memory) {
        Game memory game = games[player][gameId];

        return compareArrays(game.secret, guess);
    }

    function compareArraysExposed(
        uint8[4] calldata secretUnencrypted,
        uint8[4] calldata guess
    ) public view returns (Clue memory) {
        euint8[4] memory secret;
        for (uint i = 0; i < 4; i++) {
            secret[i] = TFHE.asEuint8(secretUnencrypted[i]);
        }
        return compareArrays(secret, guess);
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

    function endGamePossibleParams(address user) public view returns (uint64, uint64, bool) {
        Game storage game = games[user][latestGames[user]];

        return (game.lastGuessTimestamp, uint64(block.timestamp), game.lastGuessTimestamp < uint64(block.timestamp));
    }

    // debug end game
    function endGameDebug(
        address user
    ) public view returns (uint32, uint256, uint16, bool, uint8, uint8, bool, bool, bool) {
        Game storage game = games[user][latestGames[user]];
        Clue memory clue = checkGuessResult(user, latestGames[user], game.numGuesses - 1);

        return (
            game.timeStarted,
            block.timestamp - game.timeStarted,
            MAX_SECONDS_PER_GAME,
            block.timestamp - game.timeStarted > MAX_SECONDS_PER_GAME,
            clue.cows,
            clue.bulls,
            clue.bulls == 4,
            block.timestamp - game.timeStarted > MAX_SECONDS_PER_GAME || clue.bulls == 4,
            !game.isComplete
        );
    }

    function endGameAnotherTestingFunction(
        address user
    )
        public
        view
        returns (
            bool gameNotEnded,
            uint8 bulls,
            bool isCorrectGuess,
            bool isOvertime,
            uint256 gamePoints,
            uint256 lockedFundsBefore
        )
    {
        Game storage game = games[user][latestGames[user]];
        // require(!game.isComplete, "Game is already ended");

        gameNotEnded = !game.isComplete;
        Clue memory clue = checkGuessResult(user, latestGames[user], game.numGuesses - 1);

        bulls = clue.bulls;

        // if the user has not guessed the secret in 10 minutes, the game can be ended by anyone
        // require(clue.bulls == 4, "INCORRECT Guess");
        // require(
        //     (block.timestamp - game.timeStarted > MAX_SECONDS_PER_GAME) || clue.bulls == 4,
        //     "Game is not yet ended"
        // );
        isCorrectGuess = clue.bulls == 4;
        isOvertime = block.timestamp - game.timeStarted > MAX_SECONDS_PER_GAME;
        gamePoints = clue.bulls == 4 ? 9 - game.numGuesses : 0;
        // points[user] += gamePoints;
        // totalPoints += gamePoints;

        // game.isComplete = true;

        lockedFundsBefore = lockedFunds;

        // lockedFunds -= DEPOSIT_AMOUNT;

        // emit GameOutcome(user, latestGames[user], gamePoints);
    }
}
