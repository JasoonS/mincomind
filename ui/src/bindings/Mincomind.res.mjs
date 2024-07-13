// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Viem from "viem";
import * as AbiMjs from "./abi.mjs";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as TestclientMjs from "./testclient.mjs";

var address = Viem.getAddress("0x7DA25264C70EDD4944D5Ea2F163E2702c277f4e5");

var abi = AbiMjs.abi;

function make(_0, _1, _2, _3) {
  return {
          _0: _0,
          _1: _1,
          _2: _2,
          _3: _3
        };
}

function toArray(param) {
  return [
          param._0,
          param._1,
          param._2,
          param._3
        ];
}

var Guess = {
  make: make,
  toArray: toArray
};

var Clue = {};

function getContract(walletClient, publicClient) {
  return Viem.getContract({
              address: address,
              abi: abi,
              client: {
                public: Caml_option.some(publicClient)
              }
            });
}

var testclient = TestclientMjs.testclient;

var contract = Viem.getContract({
      address: address,
      abi: abi,
      client: {
        public: Caml_option.some(testclient)
      }
    });

contract.read.getLatestGameId([Viem.getAddress("0x7660788b35e06A4D6BF4985729ED1721dE351e7b")]).then(function (res) {
      console.log("latest", res);
    });

export {
  address ,
  abi ,
  Guess ,
  Clue ,
  getContract ,
  testclient ,
  contract ,
}
/* address Not a pure module */
