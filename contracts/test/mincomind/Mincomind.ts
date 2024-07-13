import { expect } from "chai";
import { ethers } from "hardhat";

import { createInstances } from "../instance";
import { getSigners } from "../signers";
import { createTransaction } from "../utils";
import { deployMincomindFixture, deployMincomindFixtureTester } from "./Mincomind.fixture";

describe("Mincomind", function () {
  before(async function () {
    this.signers = await getSigners(ethers);
  });

  before(async function () {
    // this.mincomind = await deployMincomindFixture();
    this.mincomindTester = await deployMincomindFixtureTester();
    console.log("Contract deployed at", await this.mincomindTester.getAddress());
    // this.contractAddress = await this.mincomind.getAddress();
    // this.instances = await createInstances(this.contractAddress, ethers, this.signers);
  });

  it("deployed contract exists", async function () {
    expect(this.mincomindTester).to.exist;
  });

  // not working with payable value
  it("new game should create a new game", async function () {
    console.log("running create transaction");
    // const tx = await createTransaction(this.mincomindTester.connect(this.signers.alice).initializeGameWithValues, BigInt("1000000000000000"), 1, 2, 3, 4);
    const tx = await this.mincomindTester.connect(this.signers.alice).initializeGameWithValues(1, 2, 3, 4, { value: BigInt("1000000000000000") });
    await tx.wait();
    let totalPoints = await this.mincomindTester.totalPoints();

    const secret = await this.mincomindTester.viewSecret(this.signers.alice.address, 0);
    console.log("secret", secret);
    expect(totalPoints).to.equal(0);
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
