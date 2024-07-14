type client
@module("./client.js")
external client: unit => client = "default"

module Provider = {
  @module("@apollo/client") @react.component
  external make: (~client: client, ~children: React.element) => React.element = "ApolloProvider"
}
