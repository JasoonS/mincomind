open Fetch

type error = {message: string}

let playersQuery = `
query MyQuery {
  Player(where: {active: {_eq: true}}) {
    id
    points
    numberOfGames
  }
}
    `

type player = {id: string, points: string, numberOfGames: int}
type playerInner = {@as("Player") inner: array<player>}
type playerReqResponse = {data?: playerInner, errors?: array<error>}

let fetchPlayers = async (~indexerEndpoint): option<playerReqResponse> => {
  try {
    let resp = await fetch(
      //use the env variable
      indexerEndpoint,
      {
        method: #POST,
        body: Js.Dict.fromList(list{("query", Js.Json.string(playersQuery))})
        ->Js.Json.object_
        ->Js.Json.stringify
        ->Body.string,
        headers: Headers.fromObject({
          "x-hasura-role": "public",
          "Content-type": "application/json",
        }),
      },
    )

    if Response.ok(resp) {
      let playersResponse: playerReqResponse = await Response.json(resp)->Obj.magic
      Some(playersResponse)
    } else {
      None
    }
  } catch {
  | _ => None
  }
}
