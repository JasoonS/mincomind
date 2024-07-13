import { expect } from "chai";
import { ethers } from "hardhat";

import { createInstances } from "../instance";
import { getSigners } from "../signers";
import { createTransaction } from "../utils";
import { deployMincomindFixture, deployMincomindFixtureTester, deployFakeFHEFixture } from "./Mincomind.fixture";
import exp from "constants";

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
  });

  before(async function () {
    console.log("Deploying contract");
    this.mincomind = await deployMincomindFixture();
    this.mincomindTester = await deployMincomindFixtureTester();
    console.log("Contract deployed at", await this.mincomindTester.getAddress());
    this.contractAddress = await this.mincomind.getAddress();
    // this.instances = await createInstances(this.contractAddress, ethers, this.signers);

    // this.mincomindTester = await ethers.getContractAt("MincomindTester", "0xC2442E72225CF876bE28fcf16736A445CE30a2B4");
  });

  it("deployed contract exists", async function () {
    expect(this.mincomindTester).to.exist;
  });

  // not working with payable value
  it("new game should create a new game", async function () {
    console.log("running create transaction");
    // const tx = await createTransaction(this.mincomindTester.connect(this.signers.alice).initializeGameWithValues, BigInt("1000000000000000"), 1, 2, 3, 4);
    const tx = await this.mincomindTester.connect(this.signers.alice).initializeGameWithValues(1, 2, 3, 4, { value: BigInt("1000000000000000") });
    console.log("TX submitted")
    await tx.wait();
    console.log("TX mined")
    let totalPoints = await this.mincomindTester.totalPoints();

    console.log("TX total points")
    const secret = await this.mincomindTester.viewSecret(this.signers.alice.address, 1);
    console.log("secret", secret);
    expect(totalPoints).to.equal(1);
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
