open Mincomind

@module("./gameData.jsx")
external loadDataHack: (string, 'a => React.element) => React.element = "loadDataHackHack"

let getBgColor = colour =>
  switch colour {
  | Red => "bg-red-400"
  | Orange => "bg-orange-400"
  | Yellow => "bg-yellow-400"
  | Green => "bg-green-400"
  | Blue => "bg-blue-400"
  | Purple => "bg-purple-400"
  }

module CowsAndBulls = {
  open Mincomind.Clue
  type t = Mincomind.Clue.t
  exception ExceededLimitOf4
  let make = (~bulls, ~cows) => {
    if cows + bulls <= 4 {
      Ok({bulls, cows})
    } else {
      Error(ExceededLimitOf4)
    }
  }

  type cowOrBull = Bull | Cow

  let toPegOptions = ({bulls, cows}) =>
    Belt.Array.concatMany([
      Array.make(~length=bulls, Some(Bull)),
      Array.make(~length=cows, Some(Cow)),
      Array.make(~length=4 - bulls - cows, None),
    ])

  let getBgColor = optCowOrBull =>
    switch optCowOrBull {
    | Some(Bull) => "bg-black"
    | Some(Cow) => "bg-white"
    | None => "bg-black opacity-25"
    }
}
// module Guess = {
//   open     MincoMind.Guess
//   type t<'a> = {
//     @as(0) _0: 'a,
//     @as(1) _1: 'a,
//     @as(2) _2: 'a,
//     @as(3) _3: 'a,
//   }
//
//   let make = (_0, _1, _2, _3) => {
//     _0,
//     _1,
//     _2,
//     _3,
//   }
//
//   let toArray: t<'a> => array<'a> = ({_0, _1, _2, _3}) => [_0, _1, _2, _3]
// }

type guess = {guess: Guess.t, cowsAndBulls: CowsAndBulls.t}
type guessInput = Guess.tGeneric<option<color>>
module SolutionRow = {
  @react.component
  let make = () => {
    <div className="bg-blue-300 flex items-center border w-full">
      <div className="w-14 grid grid-cols-2 gap-1 p-1">
        <div className="text-white opacity-40 pr-4"> {"solution"->React.string} </div>
      </div>
      <div className="flex gap-1 mx-auto items-center p-2 text-white">
        <div
          className={`border flex items-center h-10 w-10 drop-shadow-md rounded-full bg-gray-400`}>
          <span className="text-center m-4"> {"?"->React.string} </span>
        </div>
        <div
          className={`border flex items-center h-10 w-10 drop-shadow-md rounded-full bg-gray-400`}>
          <span className="text-center m-4"> {"?"->React.string} </span>
        </div>
        <div
          className={`border flex items-center h-10 w-10 drop-shadow-md rounded-full bg-gray-400`}>
          <span className="text-center m-4"> {"?"->React.string} </span>
        </div>
        <div
          className={`border flex items-center h-10 w-10 drop-shadow-md rounded-full bg-gray-400`}>
          <span className="text-center m-4"> {"?"->React.string} </span>
        </div>
      </div>
    </div>
  }
}

module GuessRow = {
  @react.component
  let make = (~guess: Guess.t, ~attempt: int) => {
    let clue: ContractHooks.response<Clue.t> = ContractHooks.Loading
    <div className="bg-blue-300 flex items-center border w-full">
      <div className="w-14 grid grid-cols-2 gap-1 border p-1">
        {switch clue {
        | Data(clue) =>
          clue
          ->CowsAndBulls.toPegOptions
          ->Array.mapWithIndex((optCowOrBull, i) => {
            <div
              key={i->Int.toString}
              className={`border border-blue-500 h-5 rounded-full ${CowsAndBulls.getBgColor(
                  optCowOrBull,
                )}`}
            />
          })
          ->React.array
        | Loading => "Loading clue..."->React.string
        | Err(_exn) => "Error loading clue..."->React.string
        }}
      </div>
      <div className="flex gap-1 mx-auto items-center p-2">
        <div className="text-white opacity-40 pr-4"> {" "->React.string} </div>
        {guess
        ->Guess.toArray
        ->Array.mapWithIndex((c, i) => {
          <div
            key={i->Int.toString}
            className={`border h-10 w-10 drop-shadow-md rounded-full ${getBgColor(c)}`}
          />
        })
        ->React.array}
      </div>
    </div>
  }
}

module GuessCreator = {
  @react.component
  let make = (~selectedColor: color) => {
    let (currentGuess, setCurrentGuess) = React.useState(_ => Guess.make(None, None, None, None))

    let getOptBgColor = optC =>
      switch optC {
      | Some(c) => getBgColor(c)
      | None => "bg-black opacity-25"
      }

    let set0 = _ => setCurrentGuess(prev => {...prev, _0: Some(selectedColor)})
    let set1 = _ => setCurrentGuess(prev => {...prev, _1: Some(selectedColor)})
    let set2 = _ => setCurrentGuess(prev => {...prev, _2: Some(selectedColor)})
    let set3 = _ => setCurrentGuess(prev => {...prev, _3: Some(selectedColor)})

    let allSelected =
      currentGuess._0 != None &&
      currentGuess._1 != None &&
      currentGuess._2 != None &&
      currentGuess._3 != None

    <div className="bg-blue-400 flex items-center border w-full">
      <div className="w-16 grid  text-center">
        {allSelected
          ? <button
              disabled={!allSelected}
              className="text-center text-white text-lg mx-auto border py-0 px-2">
              {` OK `->React.string}
            </button>
          : <p className="text-white text-center text-xxs leading-tight">
              {`Select colors`->React.string}
            </p>}
      </div>
      <div className="flex gap-1 justify-between p-1 mx-auto">
        <div
          onClick=set0
          className={`border h-10 w-10 drop-shadow-md rounded-full ${getOptBgColor(
              currentGuess._0,
            )}`}
        />
        <div
          onClick=set1
          className={`border h-10 w-10 drop-shadow-md rounded-full ${getOptBgColor(
              currentGuess._1,
            )}`}
        />
        <div
          onClick=set2
          className={`border h-10 w-10 drop-shadow-md rounded-full ${getOptBgColor(
              currentGuess._2,
            )}`}
        />
        <div
          onClick=set3
          className={`border h-10 w-10 drop-shadow-md rounded-full ${getOptBgColor(
              currentGuess._3,
            )}`}
        />
      </div>
    </div>
  }
}

module ColorSelector = {
  @react.component
  let make = (~selectedColor, ~setSelectedColor) => {
    let colors = [Red, Orange, Yellow, Green, Blue, Purple]
    let getBgColor = c => {
      let bgColor = getBgColor(c)
      if c == selectedColor {
        bgColor ++ " brightness-75 border border-2 border-white"
      } else {
        bgColor
      }
    }

    <div className="flex flex-col items-center w-full">
      <div className="flex gap-1 justify-between p-2">
        {colors
        ->Array.mapWithIndex((c, i) => {
          <div
            key={i->Int.toString}
            onClick={_ => setSelectedColor(_ => c)}
            className={` h-10 w-10 drop-shadow-md rounded-full ${getBgColor(
                c,
              )} pointer hover:brightness-20 `}
          />
        })
        ->React.array}
      </div>
      <p className="text-white text-center text-xs leading-tight">
        {`Click a colour, then click on a circle to select`->React.string}
      </p>
    </div>
  }
}
module EmptyRow = {
  @react.component
  let make = (~index) => {
    <div className="bg-blue-300 flex items-center border w-full">
      <div className="w-14 grid grid-cols-2 gap-1 border p-1">
        {Array.make(~length=4, None)
        ->Array.mapWithIndex((_, i) => {
          <div
            key={i->Int.toString}
            className={`border h-5 rounded-full ${CowsAndBulls.getBgColor(None)}`}
          />
        })
        ->React.array}
      </div>
      <div className="flex gap-1 mx-auto items-center p-2">
        <div className="text-white opacity-40 pr-4">
          {(8 - index)->Int.toString->React.string}
        </div>
        {Array.make(~length=4, Red)
        ->Array.mapWithIndex((c, i) => {
          <div
            key={i->Int.toString}
            className={`border h-10 w-10 drop-shadow-md rounded-full bg-black opacity-25`}
          />
        })
        ->React.array}
      </div>
    </div>
  }
}

let makeGuess = (~guess, ~cows, ~bulls): result<guess, _> => {
  CowsAndBulls.make(~cows, ~bulls)->Result.map((cowsAndBulls): guess => {
    guess,
    cowsAndBulls,
  })
}

let resultToOption = result =>
  switch result {
  | Ok(v) => Some(v)
  | Error(_) => None
  }

let mockGuesses: array<guess> = [
  makeGuess(~guess=Guess.make(Blue, Red, Orange, Yellow), ~cows=1, ~bulls=1),
  makeGuess(~guess=Guess.make(Purple, Red, Yellow, Green), ~cows=2, ~bulls=0),
  makeGuess(~guess=Guess.make(Blue, Blue, Orange, Orange), ~cows=0, ~bulls=3),
  // makeGuess(~guess=Guess.make(Yellow, Yellow, Orange, Orange), ~cows=2, ~bulls=2),
]->Array.filterMap(resultToOption)

// let emptyBoard: array<Guess.guessInput> =
//   [
//     makeGuess(~guess=Guess.make(Blue, Red, Orange, Yellow), ~cows=1, ~bulls=1),
//     makeGuess(~guess=Guess.make(Purple, Red, Yellow, Green), ~cows=2, ~bulls=0),
//     makeGuess(~guess=Guess.make(Blue, Blue, Orange, Orange), ~cows=0, ~bulls=3),
//     makeGuess(~guess=Guess.make(Yellow, Yellow, Orange, Orange), ~cows=2, ~bulls=2),
//   ]->Array.filterMap(resultToOption)

module Game = {
  @react.component
  let make = (~user, ~gameId, ~mincomind) => {
    let (selectedColor, setSelectedColor) = React.useState(_ => Red)
    let game = ContractHooks.useGame(~user, ~gameId, ~mincomind)

    switch game {
    | Data(game) =>
      let guesses = game.guesses->Array.filterWithIndex((_item, index) => index < game.numGuesses)
      <div>
        {guesses->Array.length->React.int}
        <SolutionRow />
        {Array.make(~length=8 - game.numGuesses, 0)
        ->Array.mapWithIndex((_0, index) => <EmptyRow index />)
        ->React.array}
        {guesses
        ->Array.mapWithIndex((guess, i) => {
          <GuessRow key={i->Int.toString} guess={Guess.fromArrayUnsafe(guess)} attempt={i} />
        })
        ->React.array}
        <GuessCreator selectedColor />
        <ColorSelector selectedColor setSelectedColor />
      </div>
    | Loading => `Loading game ${gameId->Int.toString}...`->React.string
    | Err(_exn) => "Error loading game..."->React.string
    }
  }
}

@react.component
let make = (~user, ~mincomind: Mincomind.instance) => {
  let latestGameId = ContractHooks.useLatestGameId(~mincomind, ~user) //="0x7660788b35e06A4D6BF4985729ED1721dE351e7b"->Viem.getAddressUnsafe,

  <div className="flex flex-col items-center max-w-md mx-auto rounded px-8">
    {switch latestGameId {
    | Data(latestGameId) => <Game user mincomind gameId=latestGameId />
    | Loading => "Checking latest game..."->React.string
    | Err(_exn) => "Error checking latest game..."->React.string
    }}
  </div>
}

/////// This is how we can get data with subscriptions on the graphql - implementation un-finished
// @react.component
// let make = (~walletClient: Viem.walletClient, ~publicClient) => {
//   loadDataHack("0x7660788b35e06A4D6BF4985729ED1721dE351e7b", data =>
//     <Child walletClient publicClient data />
//   )
// }
