import { ContractMethodArgs, Typed } from "ethers";

// import { ethers } from "hardhat";
import { TypedContractMethod } from "../types/common";

export const waitForBlock = (blockNumber: bigint, ethers: any) => {
  return new Promise((resolve, reject) => {
    const waitBlock = async (currentBlock: number) => {
      // console.log(`Block ${currentBlock} reached! Waiting ${blockNumber}...`);
      if (blockNumber <= BigInt(currentBlock)) {
        // console.log(`Block ${currentBlock} reached!`);
        await ethers.provider.off("block", waitBlock);
        resolve(blockNumber);
      }
    };
    ethers.provider.on("block", waitBlock).catch((err: any) => {
      reject(err);
    });
  });
};

export const createTransaction = async <A extends [...{ [I in keyof A]-?: A[I] | Typed }]>(
  method: TypedContractMethod<A>,
  value: string | number | bigint,
  ...params: A
) => {
  console.log("value", value);
  const gasLimit = await method.estimateGas(...params);
  const updatedParams: ContractMethodArgs<A> = [
    ...params,
    { gasLimit: Math.min(Math.round(+gasLimit.toString() * 1.2), 10000000), value: value },
  ];
  return method(...updatedParams);
};
