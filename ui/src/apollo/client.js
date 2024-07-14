import { ApolloClient, InMemoryCache, ApolloProvider } from '@apollo/client';

const client = new ApolloClient({
  uri: 'https://indexer.staging.bigdevenergy.link/b13f675/v1/graphql',
  cache: new InMemoryCache()
});

export default () => client;


// import { createWalletClient, custom } from 'viem'
// import { mainnet } from 'viem/chains'

// const client = createWalletClient({
//   chain: mainnet,
//   transport: custom(window.ethereum!)
// })
