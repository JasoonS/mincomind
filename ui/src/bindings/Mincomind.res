@module
external abi: Viem.abi = "../../../contracts/artifacts/contracts/Mincomind.sol/Mincomind.json"
let address = "0xTODO"->Viem.getAddressUnsafe

type gameId = int
type secret
type colour =
  | @as(0) Red | @as(1) Orange | @as(2) Yellow | @as(3) Green | @as(4) Blue | @as(5) Purple

module Guess = {
  type tGeneric<'a> = {
    @as(0) _0: 'a,
    @as(1) _1: 'a,
    @as(2) _2: 'a,
    @as(3) _3: 'a,
  }

  let make = (_0, _1, _2, _3) => {
    _0,
    _1,
    _2,
    _3,
  }

  let toArray: tGeneric<'a> => array<'a> = ({_0, _1, _2, _3}) => [_0, _1, _2, _3]

  type t = tGeneric<colour>
  // type guess = {guess: t<colour>, cowsAndBulls: CowsAndBulls.t}
  // type guessInput = t<option<colour>>
}

type game = {
  secret: secret,
  guesses: array<Guess.t>,
  lastGuessTimestamp: int,
  numGuesses: int,
  isComplete: bool,
  timeStarted: int,
}

module Clue = {
  type t = {
    bulls: int,
    cows: int,
  }
}

type viewFns = {
  getLatestGameId: (~user: Viem.address) => promise<gameId>,
  getGame: (~user: Viem.address, ~gameId: gameId) => promise<game>,
}

type writeFns = {
  newGame: unit => promise<unit>,
  checkGuessResult: (~user: Viem.address, ~gameId: gameId, ~guessIndex: int) => promise<Clue.t>,
  addGuess: (~guessAsArray: array<colour>) => promise<unit>,
  endGame: (~user: Viem.address) => promise<unit>,
  withdrawFunds: unit => promise<unit>,
}

type instance = Viem.contractInstance<viewFns, writeFns>
let getContract = (~client): instance => Viem.getContract({address, abi, client: {wallet: client}})
