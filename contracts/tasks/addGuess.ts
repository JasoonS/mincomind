import { task } from "hardhat/config";
import type { TaskArguments } from "hardhat/types";

import { Signers, getSigners } from "../test/signers";

task("task:addGuess")
  .addParam("guess0", "specify guess for pos 0 as int") // todo: modify to colours and map
  .addParam("guess1", "specify guess for pos 1 as int")
  .addParam("guess2", "specify guess for pos 2 as int")
  .addParam("guess3", "specify guess for pos 3 as int")
  .addParam("account", "Specify which account [alice, bob, carol, dave]")
  .setAction(async function (taskArguments: TaskArguments, hre) {
    const { ethers, deployments } = hre;
    const Mincomind = await deployments.get("Mincomind");
    const signers = await getSigners(ethers);

    const mincomind = await ethers.getContractAt("Mincomind", Mincomind.address);

    // await mincomind.connect(signers[taskArguments.account as keyof Signers]).addGuess([0, 0, 0, 0]);
    await mincomind
      .connect(signers[taskArguments.account as keyof Signers])
      .addGuess([taskArguments.guess0, taskArguments.guess1, taskArguments.guess2, taskArguments.guess3], {
        gasLimit: 30000000,
      });

    console.log("Guess added created");
  });

// npx hardhat task:addGuess --guess0 1 --guess1 1 --guess2 2 --guess3 3 --account alice --network inco
