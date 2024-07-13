type response<'data> = Loading | Err(exn) | Data('data)

let useRequest = request => {
  let (state, setState) = React.useState(_ => Loading)

  React.useEffect0(() => {
    request
    ->Promise.thenResolve(res => setState(_ => Data(res)))
    ->Promise.catch(exn => {
      setState(_ => Err(exn))
      Promise.resolve()
    })
    ->ignore
    None
  })

  state
}

let useLatestGameId = (~user: Viem.address, ~client: Viem.walletClient) => {
  let mincoMind = Mincomind.getContract(~client)
  useRequest(mincoMind.read.getLatestGameId(~user))
}

let useGame = (~user, ~gameId, ~client) => {
  let mincoMind = Mincomind.getContract(~client)
  useRequest(mincoMind.read.getGame(~user, ~gameId))
}
