type response<'data> = Loading | Err(exn) | Data('data)

let requestInEffect = (request, setState) => {
  () => {
    request
    ->Promise.thenResolve(res => setState(_ => Data(res)))
    ->Promise.catch(exn => {
      Console.error(exn)
      setState(_ => Err(exn))
      Promise.resolve()
    })
    ->ignore
    None
  }
}

let useRequest0 = request => {
  let (state, setState) = React.useState(_ => Loading)
  React.useEffect0(requestInEffect(request, setState))
  state
}
let useRequest1 = (request, deps) => {
  let (state, setState) = React.useState(_ => Loading)
  React.useEffect1(requestInEffect(request, setState), deps)
  state
}

let useRequest2 = (request, deps) => {
  let (state, setState) = React.useState(_ => Loading)
  React.useEffect2(requestInEffect(request, setState), deps)
  state
}

let useRequest3 = (request, deps) => {
  let (state, setState) = React.useState(_ => Loading)
  React.useEffect3(requestInEffect(request, setState), deps)
  state
}

let useLatestGameId = (~user: Viem.address, ~mincomind: Mincomind.instance) => {
  useRequest0(mincomind.read.getLatestGameId([user]))
}

let useGame = (~user, ~gameId, ~mincomind: Mincomind.instance) => {
  useRequest3(mincomind.read.getGame((user, gameId)), (user, gameId, mincomind))
}

let useWalletClient = () => {
  let (state, setState) = React.useState(_ => Loading)

  let dynamicContext = Dynamic.Hooks.useDynamicContext()
  let connector =
    dynamicContext.primaryWallet
    ->Js.Nullable.toOption
    ->Option.flatMap(pw => pw.connector->Js.Nullable.toOption)

  React.useEffect1(() => {
    switch (connector, state) {
    | (Some(connector), Loading) =>
      connector.getPublicClient()
      ->Promise.thenResolve(publicClient => {
        switch connector.getWalletClient() {
        | exception exn =>
          Console.error(exn)
          setState(_ => Err(exn))
        | walletClient => setState(_ => Data((walletClient, publicClient)))
        }
      })
      ->Promise.catch(exn => {
        Console.error(exn)
        setState(_ => Err(exn))
        Promise.resolve()
      })
      ->ignore
    | _ => ()
    }
    None
  }, [connector->Option.map(c => X.magic(c)["isInitialized"])])

  state
}
