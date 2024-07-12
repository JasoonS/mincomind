import { RandomContract } from "generated";

RandomContract.RandomNumber.handler(({ event, context }) => {
  context.Spin.set({
    id: event.transactionHash,
    number: Number(event.params.number),
    blockNumber: BigInt(event.blockNumber),
  });
});
