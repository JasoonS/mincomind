@react.component
let make = () => {
  <div className="mx-auto">
    <ActionButtons.NewGameActionButton onAction={_ => Console.log("new game")} />
    <ActionButtons.EndGameActionButton onAction={_ => Console.log("end game")} />
    <ActionButtons.WithdrawFundsActionButton onAction={_ => Console.log("withdraw funds")} />
  </div>
}
