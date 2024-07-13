module NewGameActionButton = {
  @react.component
  let make = (~onAction) => {
    <div className="flex justify-center space-x-4">
      <button
        className="bg-blue-400 my-2 hover:bg-blue-300 text-sm text-white font-bold py-2 px-4 rounded pointer"
        onClick={onAction}>
        {"New game"->React.string}
      </button>
    </div>
  }
}

module EndGameActionButton = {
  @react.component
  let make = (~onAction) => {
    <div className="flex justify-center space-x-4">
      <button
        className="bg-blue-400 my-2 hover:bg-blue-300 text-sm text-white font-bold py-2 px-4 rounded pointer"
        onClick={onAction}>
        {"End game"->React.string}
      </button>
    </div>
  }
}

module WithdrawFundsActionButton = {
  @react.component
  let make = (~onAction) => {
    <div className="flex justify-center space-x-4">
      <button
        className="bg-blue-400 my-2 hover:bg-blue-300 text-sm text-white font-bold py-2 px-4 rounded pointer"
        onClick={onAction}>
        {"Redeem points for pull"->React.string}
      </button>
    </div>
  }
}
