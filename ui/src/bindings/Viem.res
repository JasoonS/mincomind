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

@module("viem") external parseAbiUnsafe: string => abi = "parseAbi"
