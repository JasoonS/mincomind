@react.component
let make = () => {
  <div
    onClick={_ => {
      Js.log("New Game")
    }}>
    {"New Game"->React.string}
  </div>
}
