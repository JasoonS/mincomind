import { task } from "hardhat/config";
import type { TaskArguments } from "hardhat/types";

import { Signers, getSigners } from "../test/signers";

task("task:newGame")
  .addParam("account", "Specify which account [alice, bob, carol, dave]")
  .setAction(async function (taskArguments: TaskArguments, hre) {
    const { ethers, deployments } = hre;
    const Mincomind = await deployments.get("Mincomind");
    const signers = await getSigners(ethers);

    const mincomind = await ethers.getContractAt("Mincomind", Mincomind.address);

    await mincomind.connect(signers[taskArguments.account as keyof Signers]).newGame({ value: "1000000000000000" });

    console.log("Newgame created");
  });
