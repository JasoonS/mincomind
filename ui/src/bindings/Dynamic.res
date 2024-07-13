//
// import { DynamicContextProvider } from "@dynamic-labs/sdk-react-core";
//
// return (
//   <DynamicContextProvider
//     settings={{
//       environmentId: "XXXXX",
//     }}
//   >
//     <App />
//   </DynamicContextProvider>
// );
// @dynamic-labs/ethereum	EVM	EthereumWalletConnectors

module Ethereum = {
  type walletConnectors
  @module("@dynamic-labs/ethereum")
  external ethereumWalletConnectors: walletConnectors = "EthereumWalletConnectors"
}

module DynamicContextProvider = {
  type settings = {environmentId: string, walletConnectors?: array<Ethereum.walletConnectors>}
  @module("@dynamic-labs/sdk-react-core") @react.component
  external make: (~children: React.element, ~settings: settings) => React.element =
    "DynamicContextProvider"
}

module DynamicWidget = {
  type variant = | @as("modal") Modal | @as("dropdown") Dropdown
  @module("@dynamic-labs/sdk-react-core") @react.component
  external make: (
    ~buttonClassName: string=?,
    ~buttonContainerClassName: string=?,
    ~innerButtonComponent: React.element=?,
    ~variant: variant=?,
  ) => React.element = "DynamicWidget"
}

/*
import { useDynamicContext } from '@dynamic-labs/sdk-react-core';

const { primaryWallet } = useDynamicContext();

const getBalance = async () => {
  const publicClient = await primaryWallet?.connector?.getPublicClient();

  // Now you can use the public client to read data from the blockchain
  const balance = await publicClient?.getBalance(primaryWallet.address);
  return balance
}
*/

module Hooks = {
  type connector = {
    getPublicClient: unit => promise<Viem.publicClient>,
    getWalletClient: unit => promise<Viem.walletClient>,
  }
  type primaryWallet = {connector?: connector}
  type dynamicContext = {primaryWallet?: primaryWallet}

  @module("@dynamic-labs/sdk-react-core")
  external useDynamicContext: unit => dynamicContext = "useDynamicContext"
}
