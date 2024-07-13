type colour =
  | @as(0) Red | @as(1) Orange | @as(2) Yellow | @as(3) Green | @as(4) Blue | @as(5) Purple

let getBgColor = colour =>
  switch colour {
  | Red => "bg-red-400"
  | Orange => "bg-orange-400"
  | Yellow => "bg-yellow-400"
  | Green => "bg-green-400"
  | Blue => "bg-blue-400"
  | Purple => "bg-purple-400"
  }

module Guess = {
  type t<'a> = {
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
  let toArray: t<'a> => array<'a> = ({_0, _1, _2, _3}) => [_0, _1, _2, _3]

  type guess = t<colour>
  type guessInput = t<option<colour>>
}

module CowsAndBulls = {
  type t = {
    bulls: int,
    cows: int,
  }
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
    [
      ...Array.make(~length=bulls, Some(Bull)),
      ...Array.make(~length=cows, Some(Cow)),
      ...Array.make(~length=4 - bulls - cows, None),
    ]
  let getBgColor = optCowOrBull =>
    switch optCowOrBull {
    | Some(Bull) => "bg-black"
    | Some(Cow) => "bg-white"
    | None => "bg-gray-200"
    }
}

module GuessRow = {
  @react.component
  let make = (~guess: Guess.guess, ~cowsAndBulls: CowsAndBulls.t) => {
    <div>
      //cows and bulls
      {"Cows and bulls"->React.string}
      <div className="w-20 grid grid-cols-2 gap-1">
        {cowsAndBulls
        ->CowsAndBulls.toPegOptions
        ->Array.mapWithIndex((optCowOrBull, i) => {
          <div
            key={i->Int.toString} className={`border h-10 ${CowsAndBulls.getBgColor(optCowOrBull)}`}
          />
        })
        ->React.array}
      </div>
      {"Guess"->React.string}
      <div className="flex gap-1">
        {guess
        ->Guess.toArray
        ->Array.mapWithIndex((c, i) => {
          <div key={i->Int.toString} className={`border h-10 w-10 ${getBgColor(c)}`} />
        })
        ->React.array}
      </div>
    </div>
  }
}

@react.component
let make = () => {
  <div className="border">
    <GuessRow guess={Guess.make(Red, Purple, Orange, Yellow)} cowsAndBulls={bulls: 1, cows: 2} />
  </div>
}
