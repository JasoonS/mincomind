import { createWalletClient, custom, defineChain } from "viem";

const INCO_CHAIN = {
  id: 9090,
  name: "Inco testnet",
  nativeCurrency: {
    decimals: 18,
    name: "INCO",
    symbol: "INC",
  },
  rpcUrls: {
    default: {
      http: ["https://testnet.inco.org/"],
    },
  },
  blockExplorers: {
    default: { name: "Explorer", url: "https://explorer.testnet.inco.org/" },
  },
};

export const wrapWalletClient = (existingWalletClient, account) =>
  createWalletClient({
    account: account,
    chain: defineChain(INCO_CHAIN),
    transport: custom(existingWalletClient.transport),
  });
