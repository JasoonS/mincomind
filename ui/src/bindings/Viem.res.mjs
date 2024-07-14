// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Viem from "viem";
import * as Caml_js_exceptions from "rescript/lib/es6/caml_js_exceptions.js";
import * as WalletClientUtilsMjs from "./WalletClientUtils.mjs";

function getAddress(s) {
  var addr;
  try {
    addr = Viem.getAddress(s);
  }
  catch (raw_exn){
    var exn = Caml_js_exceptions.internalToOCamlException(raw_exn);
    return {
            TAG: "Error",
            _0: exn
          };
  }
  return {
          TAG: "Ok",
          _0: addr
        };
}

function wrapWalletClient(prim0, prim1) {
  return WalletClientUtilsMjs.wrapWalletClient(prim0, prim1);
}

var makeViemClientWithWindow = (() => {
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
  });

export {
  getAddress ,
  wrapWalletClient ,
  makeViemClientWithWindow ,
}
/* viem Not a pure module */
