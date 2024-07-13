type player = Queries.player

type playerReq = Loading | Data(array<Queries.player>) | Err(Js.Exn.t)

module Row = {
  @react.component
  let make = (~player: player, ~rowStyle: string) => {
    <tr className=rowStyle>
      <td className="py-1 px-3 text-left"> {player.id->React.string} </td>
      <td className="py-1 px-3 text-left"> {player.numberOfGames->Int.toString->React.string} </td>
      <td className="py-1 px-3 text-left"> {player.points->React.string} </td>
      <td className="py-1 px-3 text-left"> {"$"->React.string} </td>
    </tr>
  }
}

module TableInner = {
  @react.component
  let make = (~players, ~page, ~pageSize) => {
    <div>
      <table
        className="text-white border rounded border-2 border-primary p-2 m-2 bg-black bg-opacity-30">
        <thead className="m-10 text-xs bg-black">
          <tr>
            <th className="py-3 px-6 text-left"> {"Player"->React.string} </th>
            <th className="py-3 px-6 text-left"> {"#No of Games"->React.string} </th>
            <th className="py-3 px-6 text-left"> {"Points"->React.string} </th>
            <th className="py-3 px-6 text-left"> {"Inco earned"->React.string} </th>
          </tr>
        </thead>
        <tbody>
          // {switch playersReq {
          // | Data(players) =>
          {players
          ->Array.mapWithIndex((player, index) =>
            <Row
              key=player.id player rowStyle={index->Int.mod(2) == 0 ? "bg-white bg-opacity-10" : ""}
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
  let make = (~players: array<player>) => {
    let (page, setPage) = React.useState(() => 0)
    let pageSize = 10
    <div className="overflow-x-auto">
      <TableInner players page pageSize />
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
  | Some(data) => data
  | None => []
  }
}

let useFetchPlayers = (~indexerEndpoint) => {
  let (players: playerReq, setPlayers) = React.useState(_ => Loading)
  React.useEffect(() => {
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
  }, [indexerEndpoint])
  players
}

@react.component
let make = () => {
  // https://indexer.staging.bigdevenergy.link/b13f675/v1/graphql
  let playersReq = useFetchPlayers(~indexerEndpoint="http://localhost:8080/v1/graphql")

  <div>
    <div
      className="flex flex-col items-center justify-center h-screen m-0 p-0 text-primary overflow-y-hidden overflow-x-hidden">
      {switch playersReq {
      | Data(players) => <TableOuter players />
      | Loading => <div> {"loading..."->React.string} </div>
      | Err(_exn) => <div> {"Error"->React.string} </div>
      }}
    </div>
  </div>
}
