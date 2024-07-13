%%raw("import './index.css'")

switch ReactDOM.querySelector("#root") {
| Some(domElement) =>
  ReactDOM.Client.createRoot(domElement)->ReactDOM.Client.Root.render(
    <React.StrictMode>
      <Dynamic.DynamicContextProvider
        settings={
          environmentId: "cc8f4069-49e6-4958-87c6-c7ee274ddf20",
          walletConnectors: [Dynamic.Ethereum.ethereumWalletConnectors],
        }>
        <Dynamic.DynamicWidget />
        <App />
      </Dynamic.DynamicContextProvider>
    </React.StrictMode>,
  )
| None => ()
}
