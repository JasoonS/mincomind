import { task } from "hardhat/config";
import type { TaskArguments } from "hardhat/types";

import { Signers, getSigners } from "../test/signers";

task("task:views")
  .addParam("account", "Specify which account [alice, bob, carol, dave]")
  .setAction(async function (taskArguments: TaskArguments, hre) {
    const { ethers, deployments } = hre;
    const Mincomind = await deployments.get("Mincomind");
    const signers = await getSigners(ethers);

    const mincomind = await ethers.getContractAt("Mincomind", Mincomind.address);

    const player = signers[taskArguments.account as keyof Signers];

    // requires editing the contract to make this function public
    // let hasWon = await mincomind.connect(player).checkUserHasWon(player, 1);
    let hasWon = false;

    console.log("Result: " + hasWon);
  });

// npx hardhat task:endGame --account alice --network inco
