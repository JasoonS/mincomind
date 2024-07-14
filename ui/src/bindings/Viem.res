type address
@module("viem") external getAddressUnsafe: string => address = "getAddress"

let getAddress = s =>
  switch getAddressUnsafe(s) {
  | exception exn => Error(exn)
  | addr => Ok(addr)
  }
type publicClient
type walletClient
type clientOpts = {
  public?: publicClient,
  wallet?: walletClient,
}
type abi
type contractArgs = {
  address: address,
  abi: abi,
  client: clientOpts,
}

type contractInstance<'viewFns, 'writeFns> = {
  read: 'viewFns,
  write: 'writeFns,
}

@module("viem") external getContract: contractArgs => contractInstance<'a, 'b> = "getContract"
@module("viem") external parseAbiUnsafe: 'a => abi = "parseAbi"

@module("./WalletClientUtils.mjs")
external wrapWalletClient: (walletClient, ~account: address) => walletClient = "wrapWalletClient"

//// Not used - kept in case
let makeViemClientWithWindow: unit => walletClient = %raw(`
  () => {
    const {createWalletClient, defineChain, custom} = require("viem");
    createWalletClient({
      chain: defineChain({
        id: 9090,
        name: 'Inco Testnet',
        nativeCurrency: {
          decimals: 18,
          name: 'Inco Token',
          symbol: 'INCO',
        },
        rpcUrls: {
          default: { http: ['https://testnet.inco.org'] },
        },
        blockExplorers: {
          default: {
            name: 'inco explorer',
            url: 'https://explorer.testnet.inco.org',
          },
        },
        testnet: true,
      }),
      transport: custom(window.ethereum)
    })
  }
`)
