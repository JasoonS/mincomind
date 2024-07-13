@react.component
let make = () => {
  let client = ContractHooks.useWalletClient()
  <div className="p-6">

     <Game />
    <Table />

    {switch client {
    | Data((walletClient, publicClient)) => <Game walletClient publicClient />
    | Loading => "loading..."->React.string
    | Err(_) => "Error getting client check console..."->React.string
    }}
 
  </div>
}
