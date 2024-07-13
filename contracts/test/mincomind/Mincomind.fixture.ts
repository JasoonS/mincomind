import { ethers } from "hardhat";

import type { Mincomind, FakeFHE, MincomindTester } from "../../types";
import { getSigners } from "../signers";

export async function deployFakeFHEFixture(): Promise<FakeFHE> {
  const signers = await getSigners(ethers);

  const contractFactory = await ethers.getContractFactory("FakeFHE");
  const contract = await contractFactory.connect(signers.alice).deploy();
  await contract.waitForDeployment();

  return contract;
}
export async function deployMincomindFixture(): Promise<Mincomind> {
  const signers = await getSigners(ethers);

  const contractFactory = await ethers.getContractFactory("Mincomind");
  const contract = await contractFactory.connect(signers.alice).deploy();
  await contract.waitForDeployment();

  return contract;
}

export async function deployMincomindFixtureTester(): Promise<MincomindTester> {
  const signers = await getSigners(ethers);

  const contractFactory = await ethers.getContractFactory("MincomindTester");
  const contract = await contractFactory.connect(signers.alice).deploy();
  await contract.waitForDeployment();

  return contract;
}
