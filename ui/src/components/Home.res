@react.component
let make = (~mincomind: Mincomind.instance) => {
  <div className="mx-auto">
    <ActionButtons.NewGameActionButton
      onAction={_ => mincomind.write.newGame({value: "1000000000000000"})->ignore}
    />
    <ActionButtons.EndGameActionButton onAction={_ => Console.log("end game")} />
    <ActionButtons.WithdrawFundsActionButton onAction={_ => Console.log("withdraw funds")} />
  </div>
}
