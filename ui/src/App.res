type view = Home | Game | Leaderboard

@react.component
let make = () => {
  let client = ContractHooks.useWalletClient()
  let (page, setPage) = React.useState(() => Home)
  <div className="p-6">
    <div className="flex items-center w-full text-md">
      <button
        className="bg-blue-500 hover:bg-blue-700 text-white py-2 px-4 mx-2 rounded"
        onClick={_ => setPage(_ => Home)}>
        {"Home"->React.string}
      </button>
      <button
        className="bg-blue-500 hover:bg-blue-700 text-white  py-2 px-4  mx-2 rounded"
        onClick={_ => setPage(_ => Game)}>
        {"Game"->React.string}
      </button>
      <button
        className="bg-blue-500 hover:bg-blue-700 text-white  py-2 px-4  mx-2  rounded"
        onClick={_ => setPage(_ => Leaderboard)}>
        {"Leaderboard"->React.string}
      </button>
    </div>
    {switch client {
    | Data(walletClient) =>
      let mincomind = Mincomind.getContract(~walletClient)
      let user = X.magic(walletClient)["account"]["address"]
      switch page {
      | Home => <Home user mincomind />
      | Game => <Game user mincomind />
      | Leaderboard => <Table mincomind client={walletClient} />
      }
    | Loading => "loading..."->React.string
    | Err(_) => "Error getting client check console..."->React.string
    }}
  </div>
}
