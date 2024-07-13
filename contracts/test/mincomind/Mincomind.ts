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
  it("Test values are correct", async function () {
    const input = [1, 2, 3, 4]
    const check = [1, 3, 5, 3]
    const expected = [1n, 1n];

    const result = await this.algorithmTester.compareArraysDebug(input, check);
    expect(result).to.deep.equal(expected);
  });
});

describe("Mincomind", function () {
  before(async function () {
    this.signers = await getSigners(ethers);
  });

  before(async function () {
    this.mincomind = await deployMincomindFixture();
    this.mincomindTester = await deployMincomindFixtureTester();
    console.log("Contract deployed at", await this.mincomindTester.getAddress());
    this.contractAddress = await this.mincomind.getAddress();
    this.instances = await createInstances(this.contractAddress, ethers, this.signers);

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
    // let totalPoints = await this.mincomindTester.totalPoints();

    // console.log("TX total points")
    // const secret = await this.mincomindTester.viewSecret(this.signers.alice.address, 1);
    // console.log("secret", secret);
    // expect(totalPoints).to.equal(0);

    // await this.mincomindTester
    //   .connect(this.signers.alice)
    //   .addGuess([1, 3, 5, 3]);

    const check1 = [1, 3, 5, 3];
    const check2 = [1, 2, 3, 4];
    const check3 = [3, 1, 5, 6]


    const result1 = await Promise.all([this.mincomindTester.checkGuessedResultHacked(this.signers.alice.address, 1, check1), this.mincomindTester.compareArraysDebug([1, 2, 3, 4], check1)]);
    const result2 = await Promise.all([this.mincomindTester.checkGuessedResultHacked(this.signers.alice.address, 1, check2), this.mincomindTester.compareArraysDebug([1, 2, 3, 4], check2)]);
    const result3 = await Promise.all([this.mincomindTester.checkGuessedResultHacked(this.signers.alice.address, 1, check3), this.mincomindTester.compareArraysDebug([1, 2, 3, 4], check3)]);
    console.log({ result1, result2, result3 });
  });

  // it("should mint the contract", async function () {
  // const encryptedAmount = this.instances.alice.encrypt32(1000);
  // const transaction = await createTransaction(this.erc20.mint, encryptedAmount);
  // await transaction.wait();
  // // Call the method
  // const token = this.instances.alice.getTokenSignature(this.contractAddress) || {
  //   signature: "",
  //   publicKey: "",
  // };
  // const encryptedBalance = await this.erc20.balanceOf(token.publicKey, token.signature);
  // // Decrypt the balance
  // const balance = this.instances.alice.decrypt(this.contractAddress, encryptedBalance);
  // expect(balance).to.equal(1000);
  // const encryptedTotalSupply = await this.erc20.getTotalSupply(token.publicKey, token.signature);
  // // Decrypt the total supply
  // const totalSupply = this.instances.alice.decrypt(this.contractAddress, encryptedTotalSupply);
  // expect(totalSupply).to.equal(1000);
  // });

  // it("should transfer tokens between two users", async function () {
  // const encryptedAmount = this.instances.alice.encrypt32(10000);
  // const transaction = await createTransaction(this.erc20.mint, encryptedAmount);
  // await transaction.wait();
  // const encryptedTransferAmount = this.instances.alice.encrypt32(1337);
  // const tx = await createTransaction(
  //   this.erc20["transfer(address,bytes)"],
  //   this.signers.bob.address,
  //   encryptedTransferAmount,
  // );
  // await tx.wait();
  // const tokenAlice = this.instances.alice.getTokenSignature(this.contractAddress)!;
  // const encryptedBalanceAlice = await this.erc20.balanceOf(tokenAlice.publicKey, tokenAlice.signature);
  // // Decrypt the balance
  // const balanceAlice = this.instances.alice.decrypt(this.contractAddress, encryptedBalanceAlice);
  // expect(balanceAlice).to.equal(10000 - 1337);
  // const bobErc20 = this.erc20.connect(this.signers.bob);
  // const tokenBob = this.instances.bob.getTokenSignature(this.contractAddress)!;
  // const encryptedBalanceBob = await bobErc20.balanceOf(tokenBob.publicKey, tokenBob.signature);
  // // Decrypt the balance
  // const balanceBob = this.instances.bob.decrypt(this.contractAddress, encryptedBalanceBob);
  // expect(balanceBob).to.equal(1337);
  // });
});
