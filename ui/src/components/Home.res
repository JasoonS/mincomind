@react.component
let make = (~mincomind: Mincomind.instance, ~user) => {
  <div className="mx-auto">
    <ActionButtons.NewGameActionButton
      onAction={_ => mincomind.write.newGame({value: "1000000000000000"})->ignore}
    />
    <ActionButtons.EndGameActionButton onAction={_ => mincomind.write.endGame([user])->ignore} />
    <ActionButtons.WithdrawFundsActionButton
      onAction={_ => mincomind.write.withdrawFunds()->ignore}
    />
  </div>
}
