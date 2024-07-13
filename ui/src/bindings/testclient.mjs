import { createPublicClient, createWalletClient, http, custom } from "viem";
import { mainnet } from "viem/chains";

// id: 1,
//   name: 'Ethereum',
//     nativeCurrency: { name: 'Ether', symbol: 'ETH', decimals: 18 },
// rpcUrls: {
//     default: {
//     http: ['https://cloudflare-eth.com'],
//     },
// },
// blockExplorers: {
//     default: {
//     name: 'Etherscan',
//       url: 'https://etherscan.io',
//         apiUrl: 'https://api.etherscan.io/api',
//     },
// },
export const testclient = createPublicClient({
  chain: {
    blockExplorerUrls: ["https://explorer.testnet.inco.org/"],
    id: 9090,
    name: "Inco testnet",
    nativeCurrency: {
      decimals: 18,
      name: "INCO",
      symbol: "INC",
    },
    rpcUrls: { default: { http: ["https://testnet.inco.org/"] } },
  },
  transport: http(),
});

// eg: Metamask
// export const walletClient = createWalletClient({
//   chain: mainnet,
//   transport: custom(window.ethereum!),
// })
