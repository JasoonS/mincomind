//copied from the hardhat file
export const abi = [
  {
    inputs: [],
    stateMutability: "nonpayable",
    type: "constructor",
  },
  {
    inputs: [],
    name: "InvalidShortString",
    type: "error",
  },
  {
    inputs: [
      {
        internalType: "string",
        name: "str",
        type: "string",
      },
    ],
    name: "StringTooLong",
    type: "error",
  },
  {
    anonymous: false,
    inputs: [],
    name: "EIP712DomainChanged",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: false,
        internalType: "address",
        name: "player",
        type: "address",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "amount",
        type: "uint256",
      },
    ],
    name: "FundsWithdrawn",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        internalType: "address",
        name: "player",
        type: "address",
      },
      {
        indexed: false,
        internalType: "uint32",
        name: "gameId",
        type: "uint32",
      },
      {
        indexed: false,
        internalType: "uint8",
        name: "points",
        type: "uint8",
      },
    ],
    name: "GameOutcome",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        internalType: "address",
        name: "player",
        type: "address",
      },
      {
        indexed: false,
        internalType: "uint32",
        name: "gameId",
        type: "uint32",
      },
      {
        indexed: false,
        internalType: "uint8",
        name: "numGuesses",
        type: "uint8",
      },
      {
        indexed: false,
        internalType: "uint8[4]",
        name: "guess",
        type: "uint8[4]",
      },
    ],
    name: "GuessAdded",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        internalType: "address",
        name: "player",
        type: "address",
      },
      {
        indexed: false,
        internalType: "uint32",
        name: "gameId",
        type: "uint32",
      },
    ],
    name: "NewGame",
    type: "event",
  },
  {
    inputs: [],
    name: "DEPOSIT_AMOUNT",
    outputs: [
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "MAX_SECONDS_PER_GAME",
    outputs: [
      {
        internalType: "uint16",
        name: "",
        type: "uint16",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "uint8[4]",
        name: "guess",
        type: "uint8[4]",
      },
    ],
    name: "addGuess",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "player",
        type: "address",
      },
      {
        internalType: "uint32",
        name: "gameId",
        type: "uint32",
      },
      {
        internalType: "uint256",
        name: "guessIndex",
        type: "uint256",
      },
    ],
    name: "checkGuessResult",
    outputs: [
      {
        components: [
          {
            internalType: "uint8",
            name: "bulls",
            type: "uint8",
          },
          {
            internalType: "uint8",
            name: "cows",
            type: "uint8",
          },
        ],
        internalType: "struct Mincomind.Clue",
        name: "",
        type: "tuple",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "eip712Domain",
    outputs: [
      {
        internalType: "bytes1",
        name: "fields",
        type: "bytes1",
      },
      {
        internalType: "string",
        name: "name",
        type: "string",
      },
      {
        internalType: "string",
        name: "version",
        type: "string",
      },
      {
        internalType: "uint256",
        name: "chainId",
        type: "uint256",
      },
      {
        internalType: "address",
        name: "verifyingContract",
        type: "address",
      },
      {
        internalType: "bytes32",
        name: "salt",
        type: "bytes32",
      },
      {
        internalType: "uint256[]",
        name: "extensions",
        type: "uint256[]",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "user",
        type: "address",
      },
    ],
    name: "endGame",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "user",
        type: "address",
      },
      {
        internalType: "uint32",
        name: "gameId",
        type: "uint32",
      },
    ],
    name: "getGame",
    outputs: [
      {
        components: [
          {
            internalType: "euint8[4]",
            name: "secret",
            type: "uint256[4]",
          },
          {
            internalType: "uint8[4][8]",
            name: "guesses",
            type: "uint8[4][8]",
          },
          {
            internalType: "uint64",
            name: "lastGuessTimestamp",
            type: "uint64",
          },
          {
            internalType: "uint8",
            name: "numGuesses",
            type: "uint8",
          },
          {
            internalType: "bool",
            name: "isComplete",
            type: "bool",
          },
          {
            internalType: "uint32",
            name: "timeStarted",
            type: "uint32",
          },
        ],
        internalType: "struct Mincomind.Game",
        name: "",
        type: "tuple",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "user",
        type: "address",
      },
    ],
    name: "getLatestGameId",
    outputs: [
      {
        internalType: "uint32",
        name: "",
        type: "uint32",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "lockedFunds",
    outputs: [
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "newGame",
    outputs: [],
    stateMutability: "payable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "",
        type: "address",
      },
    ],
    name: "points",
    outputs: [
      {
        internalType: "uint32",
        name: "",
        type: "uint32",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "totalPoints",
    outputs: [
      {
        internalType: "uint32",
        name: "",
        type: "uint32",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "withdrawFunds",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
];
