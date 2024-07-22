import { expect } from "chai";
import { ethers } from "hardhat";

import { createInstances } from "../instance";
import { getSigners } from "../signers";
import { createTransaction } from "../utils";
import { deployMincomindFixture, deployMincomindFixtureTester, deployFakeFHEFixture } from "./Mincomind.fixture";
import exp from "constants";
import { GCProfiler } from "v8";

function sleep(ms: number) {
  return new Promise(resolve => setTimeout(resolve, ms));
}
async function waitForNextBlock() {
  // const currentBlock = await ethers.provider.getBlockNumber();
  // const desiredBlock = currentBlock + 1;

  // return await new Promise((resolve) => {
  //   ethers.provider.on("block", (blockNumber) => {
  //     if (blockNumber >= desiredBlock) {
  //       ethers.provider.off("block");
  //       resolve(0);
  //     }
  //   });
  // });
  return new Promise((resolve, reject) => {
    ethers.provider.once("block", resolve);
  });
}

describe("MincomindAlgo", function () {
  before(async function () {
    this.signers = await getSigners(ethers);
  });

  before(async function () {
    this.algorithmTester = await deployFakeFHEFixture();
  });

  // not working with payable value
  it("Test values are correct - Case 1", async function () {
    const secret = [1, 2, 3, 4];
    const check = [1, 3, 5, 3];
    const expected = [1n, 1n];

    const result = await this.algorithmTester.compareArraysDebug(secret, check);
    expect(result).to.deep.equal(expected);
  });

  it("Test values are correct - Case 2", async function () {
    const check = [4, 3, 2, 1];
    const secret = [1, 2, 3, 4];
    const expected = [0n, 4n];

    const result = await this.algorithmTester.compareArraysDebug(secret, check);
    expect(result).to.deep.equal(expected);
  });

  it("Test values are correct - Case 3", async function () {
    const secret = [1, 1, 1, 1];
    const check = [1, 1, 1, 1];
    const expected = [4n, 0n];

    const result = await this.algorithmTester.compareArraysDebug(secret, check);
    expect(result).to.deep.equal(expected);
  });

  it("Test values are correct - Case 4", async function () {
    const secret = [1, 2, 3, 4];
    const check = [1, 2, 3, 4];
    const expected = [4n, 0n];

    const result = await this.algorithmTester.compareArraysDebug(secret, check);
    expect(result).to.deep.equal(expected);
  });

  it("Test values are correct - Case 5", async function () {
    const secret = [1, 2, 3, 4];
    const check = [0, 0, 0, 0];
    const expected = [0n, 0n];

    const result = await this.algorithmTester.compareArraysDebug(secret, check);
    expect(result).to.deep.equal(expected);
  });

  it("Test values are correct - Case 6", async function () {
    const secret = [1, 2, 3, 4];
    const check = [2, 1, 1, 1];
    const expected = [0n, 2n];

    const result = await this.algorithmTester.compareArraysDebug(secret, check);
    expect(result).to.deep.equal(expected);
  });

  it("Test values are correct - Case 7", async function () {
    const secret = [4, 4, 4, 4];
    const check = [1, 1, 1, 1];
    const expected = [0n, 0n];

    const result = await this.algorithmTester.compareArraysDebug(secret, check);
    expect(result).to.deep.equal(expected);
  });

  it("Test values are correct - Case 8", async function () {
    const secret = [1, 2, 3, 4];
    const check = [2, 1, 4, 3];
    const expected = [0n, 4n];

    const result = await this.algorithmTester.compareArraysDebug(secret, check);
    expect(result).to.deep.equal(expected);
  });

  it("Test values are correct - Case 9", async function () {
    const secret = [1, 2, 2, 2];
    const check = [2, 4, 3, 3];
    const expected = [0n, 1n];

    const result = await this.algorithmTester.compareArraysDebug(secret, check);
    expect(result).to.deep.equal(expected);
  });

  it("Test values are correct - Case 10", async function () {
    const secret = [1, 2, 3, 4];
    const check = [5, 6, 7, 8];
    const expected = [0n, 0n];

    const result = await this.algorithmTester.compareArraysDebug(secret, check);
    expect(result).to.deep.equal(expected);
  });

  it("Test values are correct - Case 11", async function () {
    const secret = [5, 6, 7, 7];
    const check = [5, 6, 7, 5];
    const expected = [3n, 0n];

    const result = await this.algorithmTester.compareArraysDebug(secret, check);
    expect(result).to.deep.equal(expected);
  });

  it("Test values are correct - Case 12", async function () {
    const secret = [5, 6, 7, 0];
    const check = [0, 7, 6, 5];
    const expected = [0n, 4n];

    const result = await this.algorithmTester.compareArraysDebug(secret, check);
    expect(result).to.deep.equal(expected);
  });

  it("Test values are correct - Case 13", async function () {
    const secret = [5, 5, 5, 5];
    const check = [5, 5, 5, 5];
    const expected = [4n, 0n];

    const result = await this.algorithmTester.compareArraysDebug(secret, check);
    expect(result).to.deep.equal(expected);
  });

  it("Test values are correct - Case 14", async function () {
    const secret = [5, 5, 5, 5];
    const check = [6, 6, 6, 6];
    const expected = [0n, 0n];

    const result = await this.algorithmTester.compareArraysDebug(secret, check);
    expect(result).to.deep.equal(expected);
  });

  it("Test values are correct - Case 15", async function () {
    const secret = [1, 1, 2, 2];
    const check = [2, 2, 1, 1];
    const expected = [0n, 4n];

    const result = await this.algorithmTester.compareArraysDebug(secret, check);
    expect(result).to.deep.equal(expected);
  });

  it("Test values are correct - Case 16", async function () {
    const secret = [1, 1, 3, 4];
    const check = [2, 2, 1, 1];
    const expected = [0n, 2n];

    const result = await this.algorithmTester.compareArraysDebug(secret, check);
    expect(result).to.deep.equal(expected);
  });
});

describe("Mincomind", function () {
  before(async function () {
    this.signers = await getSigners(ethers);

    console.log("Deploying contract");
    // this.mincomind = await deployMincomindFixture();
    this.mincomindTester = await deployMincomindFixtureTester();
    console.log("Contract deployed at", await this.mincomindTester.getAddress());
    // this.contractAddress = await this.mincomind.getAddress();
    // this.instances = await createInstances(this.contractAddress, ethers, this.signers);

    // this.mincomindTester = await ethers.getContractAt("MincomindTester", "0xC2442E72225CF876bE28fcf16736A445CE30a2B4");
  });

  it("deployed contract exists", async function () {
    expect(this.mincomindTester).to.exist;
  });

  // it.only("new game should create a new game", async function () {
  //   console.log("running create transaction");
  //   // const tx = await createTransaction(this.mincomindTester.connect(this.signers.alice).initializeGameWithValues, BigInt("1000000000000000"), 1, 2, 3, 4);
  //   const tx = await this.mincomindTester.connect(this.signers.alice).initializeGameWithValues(1, 2, 3, 4, { value: BigInt("1000000000000000") });
  //   console.log("TX submitted")
  //   await tx.wait();
  //   console.log("TX mined")
  //   let totalPoints = await this.mincomindTester.totalPoints();

  //   console.log("TX total points")
  //   const secret = await this.mincomindTester.viewSecret(this.signers.alice.address, 1);
  //   console.log("secret", secret);
  //   expect(totalPoints).to.equal(1);
  // });

  it.only("user makes three guesses and gets it correct on the third guess, then starts a new game", async function () {
    console.log("Running create transaction");
    // Start a new game with a known secret
    let tx = await this.mincomindTester.connect(this.signers.alice).initializeGameWithValues(1, 2, 3, 4, { value: ethers.parseEther("0.001") });
    await tx.wait();
    console.log("Initial game started");

    // First guess
    tx = await this.mincomindTester.connect(this.signers.alice).addGuess([1, 1, 1, 1]);
    await tx.wait();
    console.log("First guess submitted");

    // Second guess
    tx = await this.mincomindTester.connect(this.signers.alice).addGuess([2, 2, 2, 2]);
    await tx.wait();
    console.log("Second guess submitted");

    // Third guess (correct guess)
    tx = await this.mincomindTester.connect(this.signers.alice).addGuess([1, 2, 3, 4]);
    await tx.wait();
    console.log("Third guess submitted");

    // Check game outcome
    console.log("game ended");
    let result = await this.mincomindTester.connect(this.signers.bob).endGamePossibleParams(this.signers.alice.address);
    console.log("result!", result);
    console.log(result);
    await waitForNextBlock();
    // await sleep(15000); o// a long wait to make sure the next block has happened - TODO: improve this to actually wait for a block
    let result2 = await this.mincomindTester.connect(this.signers.bob).endGamePossibleParams(this.signers.alice.address);
    console.log("result2!", result2);
    console.log(result2);
    let result3 = await this.mincomindTester.connect(this.signers.bob).endGameDebug(this.signers.alice.address);
    console.log("result3!", result3);
    console.log(result3);
    let result4 = await this.mincomindTester.connect(this.signers.bob).endGameAnotherTestingFunction(this.signers.alice.address);
    console.log("detailedSimulation!", result4);
    console.log(result4);

    let endGameTx = await this.mincomindTester.connect(this.signers.bob).endGame(this.signers.alice.address, { gasLimit: 29999999 });
    // let endGameTx = await this.mincomindTester.connect(this.signers.bob).endGame(this.signers.alice.address);
    // let endGameTx = await this.mincomindTester.connect(this.signers.alice).endGame(this.signers.alice.address, { gasLimit: 29999999 });
    // let endGameTx = await this.mincomindTester.connect(this.signers.bob).endGame(this.signers.alice.address, { gasLimit: 29999999 });
    console.log("submitted");
    await endGameTx.wait();
    console.log("game ended");
    let gameId = await this.mincomindTester.getLatestGameId(this.signers.alice.address);
    let game = await this.mincomindTester.getGame(this.signers.alice.address, gameId);
    console.log(game);
    expect(game.isComplete).to.be.true;
    console.log("Game completed");

    // Start a new game
    tx = await this.mincomindTester.connect(this.signers.alice).newGame({ value: ethers.parseEther("0.001") });
    await tx.wait();
    console.log("New game started");

    // Verify new game started correctly
    let newGameId = await this.mincomindTester.getLatestGameId(this.signers.alice.address);
    expect(newGameId).to.equal(gameId + 1);
    game = await this.mincomindTester.getGame(this.signers.alice.address, gameId);
    expect(game.isComplete).to.be.false;
    console.log("New game is active");
  });

  it("Check the encrypted and non encrypted functions return the same thing - Case 1", async function () {
    const secret = [1, 2, 3, 4];
    const check = [1, 3, 5, 3];

    const result = await Promise.all([
      this.mincomindTester.compareArraysExposed(secret, check),
      this.mincomindTester.compareArraysDebug(secret, check)
    ]);
    expect(result[0]).to.deep.equal(result[1]);
  });

  it("Check the encrypted and non encrypted functions return the same thing - Case 2", async function () {
    const secret = [1, 2, 3, 4];
    const check = [4, 3, 2, 1];

    const result = await Promise.all([
      this.mincomindTester.compareArraysExposed(secret, check),
      this.mincomindTester.compareArraysDebug(secret, check)
    ]);
    expect(result[0]).to.deep.equal(result[1]);
  });

  it("Check the encrypted and non encrypted functions return the same thing - Case 3", async function () {
    const secret = [1, 1, 1, 1];
    const check = [1, 1, 1, 1];

    const result = await Promise.all([
      this.mincomindTester.compareArraysExposed(secret, check),
      this.mincomindTester.compareArraysDebug(secret, check)
    ]);
    expect(result[0]).to.deep.equal(result[1]);
  });

  it("Check the encrypted and non encrypted functions return the same thing - Case 4", async function () {
    const secret = [1, 2, 3, 4];
    const check = [1, 2, 3, 4];

    const result = await Promise.all([
      this.mincomindTester.compareArraysExposed(secret, check),
      this.mincomindTester.compareArraysDebug(secret, check)
    ]);
    expect(result[0]).to.deep.equal(result[1]);
  });

  it("Check the encrypted and non encrypted functions return the same thing - Case 5", async function () {
    const secret = [1, 2, 3, 4];
    const check = [0, 0, 0, 0];

    const result = await Promise.all([
      this.mincomindTester.compareArraysExposed(secret, check),
      this.mincomindTester.compareArraysDebug(secret, check)
    ]);
    expect(result[0]).to.deep.equal(result[1]);
  });

  it("Check the encrypted and non encrypted functions return the same thing - Case 6", async function () {
    const secret = [1, 2, 3, 4];
    const check = [2, 1, 1, 1];

    const result = await Promise.all([
      this.mincomindTester.compareArraysExposed(secret, check),
      this.mincomindTester.compareArraysDebug(secret, check)
    ]);
    expect(result[0]).to.deep.equal(result[1]);
  });

  it("Check the encrypted and non encrypted functions return the same thing - Case 7", async function () {
    const secret = [4, 4, 4, 4];
    const check = [1, 1, 1, 1];

    const result = await Promise.all([
      this.mincomindTester.compareArraysExposed(secret, check),
      this.mincomindTester.compareArraysDebug(secret, check)
    ]);
    expect(result[0]).to.deep.equal(result[1]);
  });

  it("Check the encrypted and non encrypted functions return the same thing - Case 8", async function () {
    const secret = [1, 2, 3, 4];
    const check = [2, 1, 4, 3];

    const result = await Promise.all([
      this.mincomindTester.compareArraysExposed(secret, check),
      this.mincomindTester.compareArraysDebug(secret, check)
    ]);
    expect(result[0]).to.deep.equal(result[1]);
  });

  it("Check the encrypted and non encrypted functions return the same thing - Case 9", async function () {
    const secret = [1, 2, 2, 2];
    const check = [2, 4, 3, 3];

    const result = await Promise.all([
      this.mincomindTester.compareArraysExposed(secret, check),
      this.mincomindTester.compareArraysDebug(secret, check)
    ]);
    expect(result[0]).to.deep.equal(result[1]);
  });

  it("Check the encrypted and non encrypted functions return the same thing - Case 10", async function () {
    const secret = [1, 2, 3, 4];
    const check = [5, 6, 7, 8];

    const result = await Promise.all([
      this.mincomindTester.compareArraysExposed(secret, check),
      this.mincomindTester.compareArraysDebug(secret, check)
    ]);
    expect(result[0]).to.deep.equal(result[1]);
  });

  it("Check the encrypted and non encrypted functions return the same thing - Case 11", async function () {
    const secret = [5, 6, 7, 7];
    const check = [5, 6, 7, 5];

    const result = await Promise.all([
      this.mincomindTester.compareArraysExposed(secret, check),
      this.mincomindTester.compareArraysDebug(secret, check)
    ]);
    expect(result[0]).to.deep.equal(result[1]);
  });

  it("Check the encrypted and non encrypted functions return the same thing - Case 12", async function () {
    const secret = [5, 6, 7, 0];
    const check = [0, 7, 6, 5];

    const result = await Promise.all([
      this.mincomindTester.compareArraysExposed(secret, check),
      this.mincomindTester.compareArraysDebug(secret, check)
    ]);
    expect(result[0]).to.deep.equal(result[1]);
  });

  it("Check the encrypted and non encrypted functions return the same thing - Case 13", async function () {
    const secret = [5, 5, 5, 5];
    const check = [5, 5, 5, 5];

    const result = await Promise.all([
      this.mincomindTester.compareArraysExposed(secret, check),
      this.mincomindTester.compareArraysDebug(secret, check)
    ]);
    expect(result[0]).to.deep.equal(result[1]);
  });

  it("Check the encrypted and non encrypted functions return the same thing - Case 14", async function () {
    const secret = [5, 5, 5, 5];
    const check = [6, 6, 6, 6];

    const result = await Promise.all([
      this.mincomindTester.compareArraysExposed(secret, check),
      this.mincomindTester.compareArraysDebug(secret, check)
    ]);
    expect(result[0]).to.deep.equal(result[1]);
  });

  it("Check the encrypted and non encrypted functions return the same thing - Case 15", async function () {
    const secret = [1, 1, 2, 2];
    const check = [2, 2, 1, 1];

    const result = await Promise.all([
      this.mincomindTester.compareArraysExposed(secret, check),
      this.mincomindTester.compareArraysDebug(secret, check)
    ]);
    expect(result[0]).to.deep.equal(result[1]);
  });

  it("Check the encrypted and non encrypted functions return the same thing - Case 16", async function () {
    const secret = [1, 1, 3, 4];
    const check = [2, 2, 1, 1];

    const result = await Promise.all([
      this.mincomindTester.compareArraysExposed(secret, check),
      this.mincomindTester.compareArraysDebug(secret, check)
    ]);
    expect(result[0]).to.deep.equal(result[1]);
  });
});

describe("Mincomind E2E Scenario", function () {
  // before(async function () {
  //   this.signers = await getSigners(ethers);
  // });

  // before(async function () {
  //   console.log("Deploying contract");
  //   const MincomindTester = await ethers.getContractFactory("MincomindTester");
  //   this.mincomindTester = await MincomindTester.deploy({ value: ethers.parseEther("0.001") });
  //   console.log("Contract deployed at", await this.mincomindTester.getAddress());
  // });

  before(async function () {
    this.signers = await getSigners(ethers);

    console.log("Deploying contract");
    // this.mincomind = await deployMincomindFixture();
    this.mincomindTester = await deployMincomindFixtureTester();
    console.log("Contract deployed at", await this.mincomindTester.getAddress());
    // this.contractAddress = await this.mincomind.getAddress();
    // this.instances = await createInstances(this.contractAddress, ethers, this.signers);

    // this.mincomindTester = await ethers.getContractAt("MincomindTester", "0xC2442E72225CF876bE28fcf16736A445CE30a2B4");
  });

  it("should complete an E2E scenario", async function () {
    // Start a new game and set the secret

    console.log("beginBB")
    let tx = await this.mincomindTester.connect(this.signers.bob).initializeGameWithValues(1, 2, 3, 4, { value: ethers.parseEther("0.001") });
    console.log("submittingBB")
    await tx.wait();
    console.log("begin")
    const startGameTx = await this.mincomindTester.connect(this.signers.alice).newGame({ value: ethers.parseEther("0.001") });
    console.log("Submitting")
    await startGameTx.wait();
    console.log("Game started");
    const hackGameToUseKnownValues = await this.mincomindTester.connect(this.signers.alice).updateValuesForPlayer(this.signers.alice.address, 1, 2, 3, 4, { value: ethers.parseEther("0.001") });
    // const startGameTx = await this.mincomindTester.connect(this.signers.alice).initializeGameWithValues(1, 2, 3, 4, { value: ethers.parseEther("0.001") });
    let gameId = await this.mincomindTester.getLatestGameId(this.signers.alice.address);
    expect(gameId).to.equal(1);
    console.log("Game started with ID:", gameId.toString());

    // Make guesses
    const guesses = [
      [1, 1, 2, 2],
      [1, 1, 4, 5],
      [1, 2, 1, 4],
      [1, 2, 3, 4]
    ];

    for (let i = 0; i < guesses.length; i++) {
      const guessTx = await this.mincomindTester.connect(this.signers.alice).addGuess(guesses[i]);
      await guessTx.wait();
      console.log(`Guess ${i + 1} submitted:`, guesses[i]);
    }

    // End the game
    const endGameTx = await this.mincomindTester.endGame(this.signers.alice.address);
    await endGameTx.wait();
    console.log("Game ended");

    // Verify points
    const points = await this.mincomindTester.points(this.signers.alice.address);
    expect(points).to.equal(5);
    console.log("User points:", points.toString());

    // Withdraw points
    let [usersPoints, usersAvailableBalance] = await this.mincomindTester.getUsersPointsAndBalance(
      this.signers.alice.address
    );
    let availableContractBalancBefore = await this.mincomindTester.getAvailableContractBalance();
    console.log("User points:", usersPoints.toString());
    console.log("User available balance:", usersAvailableBalance.toString());
    console.log("Contract available balance before:", availableContractBalancBefore.toString());

    const withdrawTx = await this.mincomindTester.withdrawFunds();
    await withdrawTx.wait();
    console.log("Funds withdrawn");
  });
});
