%%raw("import './index.css'")

let incoNetwork: Dynamic.DynamicContextProvider.network = {
  blockExplorerUrls: ["https://explorer.testnet.inco.org/"],
  chainId: 9090,
  chainName: "Inco testnet",
  iconUrls: [
    "data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iNjAiIGhlaWdodD0iNjAiIHZpZXdCb3g9IjAgMCA2MCA2MCIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPHBhdGggZD0iTTAgOS42QzAgNC4yOTgwNyA0LjI5ODA3IDAgOS42IDBINTAuNEM1NS43MDE5IDAgNjAgNC4yOTgwNyA2MCA5LjZWNTAuNEM2MCA1NS43MDE5IDU1LjcwMTkgNjAgNTAuNCA2MEg5LjZDNC4yOTgwNyA2MCAwIDU1LjcwMTkgMCA1MC40VjkuNloiIGZpbGw9IiMzNjczRjUiLz4KPHBhdGggZD0iTTExLjQwMjMgNDEuNEwxNy40NTAzIDE4LjZIMjQuMDAyM0wxNy45NTQzIDQxLjRIMTEuNDAyM1oiIGZpbGw9IndoaXRlIi8+CjxwYXRoIGQ9Ik0yNC4wMDIzIDQxLjRMMzAuMDUwMyAxOC42SDM2LjYwMjNMMzAuNTU0MyA0MS40SDI0LjAwMjNaIiBmaWxsPSJ3aGl0ZSIvPgo8cGF0aCBkPSJNMzYuNjAyMyA0MS40TDQyLjY1MDMgMTguNkg0OS4yMDIzTDQzLjE1NDMgNDEuNEgzNi42MDIzWiIgZmlsbD0id2hpdGUiLz4KPC9zdmc+Cg==",
  ],
  name: "Inco testnet",
  nativeCurrency: {
    decimals: 18,
    name: "INCO",
    symbol: "INC",
  },
  networkId: 9090,
  rpcUrls: ["https://testnet.inco.org/"],
  vanityName: "Inco testnet",
  shortName: "inco",
  chain: "inco",
}

switch ReactDOM.querySelector("#root") {
| Some(domElement) =>
  ReactDOM.Client.createRoot(domElement)->ReactDOM.Client.Root.render(
    <React.StrictMode>
      <Dynamic.DynamicContextProvider
        settings={
          environmentId: "cc8f4069-49e6-4958-87c6-c7ee274ddf20",
          walletConnectors: [Dynamic.Ethereum.ethereumWalletConnectors],
          overrides: {
            evmNetworks: _ => [incoNetwork],
          },
        }>
        <Dynamic.DynamicWidget />
        <App />
      </Dynamic.DynamicContextProvider>
    </React.StrictMode>,
  )
| None => ()
}
