/* import { ApolloClient, InMemoryCache, ApolloProvider } from '@apollo/client';

const client = new ApolloClient({
  uri: 'https://indexer.staging.bigdevenergy.link/b13f675/v1/graphql',
  cache: new InMemoryCache()
});

export default () => client; */

import {
  ApolloClient,
  InMemoryCache,
  ApolloProvider,
  split,
  HttpLink,
} from "@apollo/client";
import { WebSocketLink } from "@apollo/link-ws";
import { getMainDefinition } from "@apollo/client/utilities";
import { indexerEndpoint, wssIndexerEndpoint } from "../Config.res.mjs";

// HTTP link for queries and mutations
const httpLink = new HttpLink({
  uri: indexerEndpoint,
});

// WebSocket link for subscriptions
const wsLink = new WebSocketLink({
  uri: wssIndexerEndpoint,
  options: {
    reconnect: true,
  },
});

// Split links based on operation type
const splitLink = split(
  ({ query }) => {
    const definition = getMainDefinition(query);
    return (
      definition.kind === "OperationDefinition" &&
      definition.operation === "subscription"
    );
  },
  wsLink,
  httpLink
);

const client = new ApolloClient({
  link: splitLink,
  cache: new InMemoryCache(),
});

export default () => client;

// import { createWalletClient, custom } from 'viem'
// import { mainnet } from 'viem/chains'

// const client = createWalletClient({
//   chain: mainnet,
//   transport: custom(window.ethereum!)
// })
