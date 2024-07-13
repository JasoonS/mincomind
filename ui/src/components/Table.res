type player = {
  address: string,
  points: int,
  numberOfGamesPlayed: int,
}
module Row = {
  @react.component
  let make = (~player, ~rowStyle: string) => {
    <tr className=rowStyle>
      <td className="py-1 px-3 text-left"> {player.address->React.string} </td>
      <td className="py-1 px-3 text-left">
        {player.numberOfGamesPlayed->Int.toString->React.string}
      </td>
      <td className="py-1 px-3 text-left"> {player.points->Int.toString->React.string} </td>
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
              key=player.address
              player
              rowStyle={index->Int.mod(2) == 0 ? "bg-white bg-opacity-10" : ""}
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

@react.component
let make = () => {
  let dummyData = [
    {
      address: "0x1234",
      points: 19,
      numberOfGamesPlayed: 12,
    },
    {
      address: "0x2345",
      points: 12,
      numberOfGamesPlayed: 14,
    },
    {
      address: "0x43112",
      points: 10,
      numberOfGamesPlayed: 8,
    },
    {
      address: "0x4123",
      points: 7,
      numberOfGamesPlayed: 7,
    },
    {
      address: "0x14215",
      points: 2,
      numberOfGamesPlayed: 2,
    },
  ]

  let players = dummyData

  <div>
    <div
      className="flex flex-col items-center justify-center h-screen m-0 p-0 text-primary overflow-y-hidden overflow-x-hidden">
      <TableOuter players />
    </div>
  </div>
}
