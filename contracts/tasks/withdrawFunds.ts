import { task } from "hardhat/config";
import type { TaskArguments } from "hardhat/types";

import { Signers, getSigners } from "../test/signers";

task("task:withdrawFunds")
  .addParam("account", "Specify which account [alice, bob, carol, dave]")
  .setAction(async function (taskArguments: TaskArguments, hre) {
    const { ethers, deployments } = hre;
    const Mincomind = await deployments.get("Mincomind");
    const signers = await getSigners(ethers);

    const mincomind = await ethers.getContractAt("Mincomind", Mincomind.address);

    const player = signers[taskArguments.account as keyof Signers];

    await mincomind.connect(player).withdrawFunds();

    console.log("Funds withdrawn for : " + player);
  });

// npx hardhat task:withdrawFunds --account alice --network inco
