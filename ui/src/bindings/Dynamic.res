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
  type nativeCurrency = {
    /**
     *
     * @type {string}
     * @memberof NativeCurrency
     */
    name: string,
    /**
     *
     * @type {string}
     * @memberof NativeCurrency
     */
    symbol: string,
    /**
     *
     * @type {number}
     * @memberof NativeCurrency
     */
    decimals: int,
  }

  type network = {
    /**
     * A light client, compared to a full node, tracks only pieces of certain information on a blockchain. Light clients do not track the entire state of a blockchain and also do not contain every transaction/block of a chain.
     * @type {string}
     * @memberof NetworkConfiguration
     */
    lcdUrl?: string,
    /**
     * [Deprecated] use `name` property instead
     * @type {string}
     * @memberof NetworkConfiguration
     */
    chainName?: string,
    /**
     *
     * @type {string}
     * @memberof NetworkConfiguration
     */
    name: string,
    /**
     *
     * @type {string}
     * @memberof NetworkConfiguration
     */
    shortName: string,
    /**
     *
     * @type {string}
     * @memberof NetworkConfiguration
     */
    chain: string,
    /**
     *
     * @type {int}
     * @memberof NetworkConfiguration
     */
    chainId: int,
    /**
     *
     * @type {NameService}
     * @memberof NetworkConfiguration
     */
    /**
     *
     * @type {int}
     * @memberof NetworkConfiguration
     */
    // nameService?: NameService,

    networkId: int,
    /**
     *
     * @type {Array<string>}
     * @memberof NetworkConfiguration
     */
    iconUrls: array<string>,
    /**
     *
     * @type {NativeCurrency}
     * @memberof NetworkConfiguration
     */
    /**
     *
     * @type {Array<string>}
     * @memberof NetworkConfiguration
     */
    nativeCurrency: nativeCurrency,
    rpcUrls: array<string>,
    /**
     * Contains the client private RPC urls
     * @type {Array<string>}
     * @memberof NetworkConfiguration
     */
    privateCustomerRpcUrls?: array<string>,
    /**
     *
     * @type {Array<string>}
     * @memberof NetworkConfiguration
     */
    blockExplorerUrls: array<string>,
    /**
     *
     * @type {string}
     * @memberof NetworkConfiguration
     */
    vanityName?: string,
  }

  @module("@dynamic-labs/sdk-react-core")
  external mergeNetworks: (array<network>, array<network>) => array<network> = "mergeNetworks"
  type settingsOverrides = {evmNetworks?: array<network> => array<network>}
  type settings = {
    environmentId: string,
    walletConnectors?: array<Ethereum.walletConnectors>,
    overrides?: settingsOverrides,
  }
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

module Hooks = {
  type publicClient
  type walletClient
  type connector = {
    getPublicClient: unit => promise<Viem.publicClient>,
    getWalletClient: unit => Viem.walletClient,

  }
  type primaryWallet = {connector: Js.Nullable.t<connector>}
  type network = {networkChainId?: int, networkName?: string}
  type walletConnector = {
    supportsNetworkSwitching: unit => bool,
    switchNetwork: network => promise<unit>,
  }
  type dynamicContext = {
    primaryWallet: Js.Nullable.t<primaryWallet>,
    walletConnector: walletConnector,
  }

  @module("@dynamic-labs/sdk-react-core")
  external useDynamicContext: unit => dynamicContext = "useDynamicContext"
}
