import { ethers } from "hardhat";

import type { Mincomind } from "../../types";
import { getSigners } from "../signers";

export async function deployMincomindFixture(): Promise<Mincomind> {
  const signers = await getSigners(ethers);

  const contractFactory = await ethers.getContractFactory("Mincomind");
  const contract = await contractFactory.connect(signers.alice).deploy();
  await contract.waitForDeployment();

  return contract;
}
