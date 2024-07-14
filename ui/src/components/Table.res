type player = Queries.player

type playerReq = Loading | Data(array<Queries.player>) | Err(Js.Exn.t)

module Row = {
  @react.component
  let make = (
    ~player: player,
    ~rowStyle: string,
    ~mincomind: Mincomind.instance,
    ~availableFunds: ContractHooks.response<bigint>,
    ~totalPoints: ContractHooks.response<int>,
    ~lockedFunds: ContractHooks.response<bigint>,
  ) => {
    let amountToClaim = switch (availableFunds, totalPoints, lockedFunds) {
    | (Data(availableFunds), Data(totalPoints), Data(lockedFunds)) =>
      let totalAvailable = BigInt.sub(availableFunds, lockedFunds)
      let numerator = BigInt.mul(BigInt.fromStringExn(player.points), totalAvailable)
      let result = BigInt.div(
        numerator,
        BigInt.mul(BigInt.fromInt(totalPoints + 1), 100000000000000n),
      )
      result->BigInt.toString
    | _ => "Loading"
    }
    // let amountToClaim = BigInt(player.points) * availableFunds / totalPoints
    <tr className=rowStyle>
      <td className="py-1 px-3 text-left">
        <a
          href={`https://explorer.testnet.inco.org/address/${player.id}`}
          target="_blank"
          rel="no-referrer no-openner"
          className="pointer hover:opacity-70">
          <span className="bg-blue-100 pointer p-1 mx-2 hover:bg-blue-800 rounded">
            {"🔗"->React.string}
          </span>
          {"  "->React.string}
          {player.id->React.string}
        </a>
      </td>
      <td className="py-1 px-3 text-left"> {player.numberOfGames->Int.toString->React.string} </td>
      <td className="py-1 px-3 text-left"> {player.points->React.string} </td>
      // <td className="py-1 px-3 text-left"> {`${amountToClaim}$`->React.string} </td>
    </tr>
  }
}

module TableInner = {
  @react.component
  let make = (
    ~players,
    ~page,
    ~pageSize,
    ~mincomind: Mincomind.instance,
    ~client: Viem.walletClient,
  ) => {
    let _ = client
    let toralPoints = ContractHooks.useTotalPoints(~mincomind)
    let lockedFunds = ContractHooks.useLockedFunds(~mincomind)
    let availableFunds: ContractHooks.response<bigint> = Data(100000000000000000n)
    <div>
      <table
        className="text-white border rounded border-2 border-primary p-2 m-2 bg-black bg-opacity-30">
        <thead className="m-10 text-xs bg-black">
          <tr>
            <th className="py-3 px-6 text-left"> {"Player"->React.string} </th>
            <th className="py-3 px-6 text-left"> {"#No of Games"->React.string} </th>
            <th className="py-3 px-6 text-left"> {"Points"->React.string} </th>
            // <th className="py-3 px-6 text-left"> {"Inco earned"->React.string} </th>
          </tr>
        </thead>
        <tbody>
          // {switch playersReq {
          // | Data(players) =>
          {players
          ->Array.mapWithIndex((player, index) =>
            <Row
              key=player.id
              player
              rowStyle={index->Int.mod(2) == 0 ? "bg-white bg-opacity-10" : ""}
              mincomind
              availableFunds
              totalPoints=toralPoints
              lockedFunds
            />
          )
          ->React.array}
          // | Loading => <tr> {"loading..."->React.string} </tr>
          // | Err(_exn) => <tr> {"Error"->React.string} </tr>
          // }}
        </tbody>
      </table>
    </div>
  }
}

module TableOuter = {
  @react.component
  let make = (
    ~players: array<player>,
    ~mincomind: Mincomind.instance,
    ~client: Viem.walletClient,
  ) => {
    let (page, setPage) = React.useState(() => 0)
    let pageSize = 10
    <div className="overflow-x-auto">
      <TableInner players page pageSize mincomind client />
      <Pagination
        activePage={page + 1}
        numPages={players->Array.length / pageSize - 1}
        onChange={newPage => setPage(_ => newPage - 1)}
      />
    </div>
  }
}

let formatFetch = (~playersResponse: Queries.playerReqResponse) => {
  switch playersResponse.data {
  | Some(data) => data.inner
  | None => []
  }
}

let useFetchPlayers = (~indexerEndpoint) => {
  let (players: playerReq, setPlayers) = React.useState(_ => Loading)
  React.useEffect0(() => {
    let fetchPlayers = async indexerEndpoint => {
      let playersResponseOpt: option<Queries.playerReqResponse> = await Queries.fetchPlayers(
        ~indexerEndpoint,
      )

      switch playersResponseOpt {
      | Some(playersResponse) =>
        let formatted = formatFetch(~playersResponse)
        setPlayers(_ => Data(formatted))

      | _ => setPlayers(_ => Loading)
      }
    }
    let _ = fetchPlayers(indexerEndpoint)
    None
  })
  players
}

@react.component
let make = (~mincomind: Mincomind.instance, ~client: Viem.walletClient) => {
  let playersReq = useFetchPlayers(
    ~indexerEndpoint="https://indexer.staging.bigdevenergy.link/7f6ebc9/v1/graphql",
  )
  // let playersReq = useFetchPlayers(~indexerEndpoint="http://localhost:8080/v1/graphql")

  <div>
    <div
      className="flex flex-col items-center justify-center h-screen m-0 p-0 text-primary overflow-y-hidden overflow-x-hidden">
      {switch playersReq {
      | Data(players) => <TableOuter players mincomind client />
      | Loading => <div> {"loading..."->React.string} </div>
      | Err(_exn) => <div> {"Error"->React.string} </div>
      }}
    </div>
  </div>
}
