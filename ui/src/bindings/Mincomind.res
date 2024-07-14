// type hardhatAbi = {abi: Viem.abi}
// @module
// external hardhatAbi: hardhatAbi =
//   "../../../contracts/artifacts/contracts/Mincomind.sol/Mincomind.json"
let address = "0x7DA25264C70EDD4944D5Ea2F163E2702c277f4e5"->Viem.getAddressUnsafe
@module("./abi.mjs") external abi: Viem.abi = "abi"
// let abi =
//   ["function getLatestGameId(address user) public view returns (uint32)"]->Viem.parseAbiUnsafe

type gameId = int
type secret
type color =
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

  type t = tGeneric<color>
  type tAsArray = array<color>
  let fromArrayUnsafe = (tAsArray): t => {
    _0: tAsArray[0]->Option.getUnsafe,
    _1: tAsArray[1]->Option.getUnsafe,
    _3: tAsArray[3]->Option.getUnsafe,
    _2: tAsArray[2]->Option.getUnsafe,
  }
  let toArray: tGeneric<'a> => array<'a> = ({_0, _1, _2, _3}) => [_0, _1, _2, _3]

  // type guess = {guess: t<colour>, cowsAndBulls: CowsAndBulls.t}
  // type guessInput = t<option<colour>>
}

type game = {
  secret: secret,
  guesses: array<Guess.tAsArray>,
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
  getLatestGameId: array<Viem.address> => promise<gameId>,
  getGame: ((Viem.address, gameId)) => promise<game>,
  checkGuessResult: ((Viem.address, gameId, int)) => promise<Clue.t>,
}

type options = {value: string}

type writeFns = {
  newGame: options => promise<unit>,
  addGuess: array<array<color>> => promise<unit>,
  endGame: (~user: Viem.address) => promise<unit>,
  withdrawFunds: unit => promise<unit>,
}

type instance = Viem.contractInstance<viewFns, writeFns>

let getContract = (~walletClient: Viem.walletClient): instance => {
  let contract = Viem.getContract({
    address,
    abi,
    client: {
      wallet: walletClient,
      public: walletClient->X.magic,
    },
  })

  // Console.log2("contract created", contract)
  contract
}

// @module("./testclient.mjs") external testclient: Viem.publicClient = "testclient"
//
// let contract: instance = Viem.getContract({
//   address,
//   abi,
//   client: {public: testclient},
// })
//
// let _ =
//   contract.read.getLatestGameId([
//     "0x7660788b35e06A4D6BF4985729ED1721dE351e7b"->Viem.getAddressUnsafe,
//   ])->Promise.thenResolve(res => Console.log2("latest", res))
