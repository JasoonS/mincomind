// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";
import * as Spinner from "./Spinner.res.mjs";
import * as Mincomind from "../bindings/Mincomind.res.mjs";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as Core__Array from "@rescript/core/src/Core__Array.res.mjs";
import * as Core__Result from "@rescript/core/src/Core__Result.res.mjs";
import * as ContractHooks from "../hooks/ContractHooks.res.mjs";
import * as GameDataJsx from "./gameData.jsx";
import * as Caml_exceptions from "rescript/lib/es6/caml_exceptions.js";
import * as JsxRuntime from "react/jsx-runtime";

function loadDataHack(prim0, prim1) {
  return GameDataJsx.loadDataHackHack(prim0, prim1);
}

function getBgColor(colour) {
  switch (colour) {
    case 0 :
        return "bg-red-400";
    case 1 :
        return "bg-orange-400";
    case 2 :
        return "bg-yellow-400";
    case 3 :
        return "bg-green-400";
    case 4 :
        return "bg-blue-400";
    case 5 :
        return "bg-purple-400";
    
  }
}

var ExceededLimitOf4 = /* @__PURE__ */Caml_exceptions.create("Game.CowsAndBulls.ExceededLimitOf4");

function make(bulls, cows) {
  if ((cows + bulls | 0) <= 4) {
    return {
            TAG: "Ok",
            _0: {
              bulls: bulls,
              cows: cows
            }
          };
  } else {
    return {
            TAG: "Error",
            _0: {
              RE_EXN_ID: ExceededLimitOf4
            }
          };
  }
}

function toPegOptions(param) {
  var cows = param.cows;
  var bulls = param.bulls;
  return Belt_Array.concatMany([
              Core__Array.make(bulls, "Bull"),
              Core__Array.make(cows, "Cow"),
              Core__Array.make((4 - bulls | 0) - cows | 0, undefined)
            ]);
}

function getBgColor$1(optCowOrBull) {
  if (optCowOrBull !== undefined) {
    if (optCowOrBull === "Bull") {
      return "bg-black";
    } else {
      return "bg-white";
    }
  } else {
    return "bg-black opacity-25";
  }
}

var CowsAndBulls = {
  ExceededLimitOf4: ExceededLimitOf4,
  make: make,
  toPegOptions: toPegOptions,
  getBgColor: getBgColor$1
};

function Game$SolutionRow(props) {
  return JsxRuntime.jsxs("div", {
              children: [
                JsxRuntime.jsx("div", {
                      children: JsxRuntime.jsx("div", {
                            children: "solution",
                            className: "text-white opacity-40 pr-4"
                          }),
                      className: "w-14 grid grid-cols-2 gap-1 p-1"
                    }),
                JsxRuntime.jsxs("div", {
                      children: [
                        JsxRuntime.jsx("div", {
                              children: JsxRuntime.jsx("span", {
                                    children: "?",
                                    className: "text-center m-4"
                                  }),
                              className: "border flex items-center h-10 w-10 drop-shadow-md rounded-full bg-gray-400"
                            }),
                        JsxRuntime.jsx("div", {
                              children: JsxRuntime.jsx("span", {
                                    children: "?",
                                    className: "text-center m-4"
                                  }),
                              className: "border flex items-center h-10 w-10 drop-shadow-md rounded-full bg-gray-400"
                            }),
                        JsxRuntime.jsx("div", {
                              children: JsxRuntime.jsx("span", {
                                    children: "?",
                                    className: "text-center m-4"
                                  }),
                              className: "border flex items-center h-10 w-10 drop-shadow-md rounded-full bg-gray-400"
                            }),
                        JsxRuntime.jsx("div", {
                              children: JsxRuntime.jsx("span", {
                                    children: "?",
                                    className: "text-center m-4"
                                  }),
                              className: "border flex items-center h-10 w-10 drop-shadow-md rounded-full bg-gray-400"
                            })
                      ],
                      className: "flex gap-1 mx-auto items-center p-2 text-white"
                    })
              ],
              className: "bg-blue-300 flex items-center border w-full"
            });
}

var SolutionRow = {
  make: Game$SolutionRow
};

function Game$CluePegs(props) {
  var clue = ContractHooks.useClue(props.user, props.gameId, props.attempt, props.mincomind);
  if (typeof clue !== "object") {
    return JsxRuntime.jsx("div", {
                children: JsxRuntime.jsx(Spinner.make, {}),
                className: "w-full flex justify-center items-center"
              });
  } else if (clue.TAG === "Err") {
    return "Error loading clue...";
  } else {
    return toPegOptions(clue._0).map(function (optCowOrBull, i) {
                return JsxRuntime.jsx("div", {
                            className: "border border-blue-500 h-5 rounded-full " + getBgColor$1(optCowOrBull)
                          }, i.toString());
              });
  }
}

var CluePegs = {
  make: Game$CluePegs
};

function Game$GuessRow(props) {
  var attempt = props.attempt;
  return JsxRuntime.jsxs("div", {
              children: [
                JsxRuntime.jsx("div", {
                      children: JsxRuntime.jsx(Game$CluePegs, {
                            user: props.user,
                            gameId: props.gameId,
                            attempt: attempt,
                            mincomind: props.mincomind
                          }),
                      className: "w-14 grid grid-cols-2 gap-1 border p-1"
                    }),
                JsxRuntime.jsxs("div", {
                      children: [
                        JsxRuntime.jsx("div", {
                              children: (attempt + 1 | 0).toString(),
                              className: "text-white opacity-40 pr-4"
                            }),
                        Mincomind.Guess.toArray(props.guess).map(function (c, i) {
                              return JsxRuntime.jsx("div", {
                                          className: "border h-10 w-10 drop-shadow-md rounded-full " + getBgColor(c)
                                        }, i.toString());
                            })
                      ],
                      className: "flex gap-1 mx-auto items-center p-2"
                    })
              ],
              className: "bg-blue-300 flex items-center border w-full"
            });
}

var GuessRow = {
  make: Game$GuessRow
};

function Game$GuessCreator(props) {
  var mincomind = props.mincomind;
  var selectedColor = props.selectedColor;
  var match = React.useState(function () {
        return Mincomind.Guess.make(undefined, undefined, undefined, undefined);
      });
  var setCurrentGuess = match[1];
  var currentGuess = match[0];
  var getOptBgColor = function (optC) {
    if (optC !== undefined) {
      return getBgColor(optC);
    } else {
      return "bg-black opacity-25";
    }
  };
  var set0 = function (param) {
    setCurrentGuess(function (prev) {
          return {
                  _0: selectedColor,
                  _1: prev._1,
                  _2: prev._2,
                  _3: prev._3
                };
        });
  };
  var set1 = function (param) {
    setCurrentGuess(function (prev) {
          return {
                  _0: prev._0,
                  _1: selectedColor,
                  _2: prev._2,
                  _3: prev._3
                };
        });
  };
  var set2 = function (param) {
    setCurrentGuess(function (prev) {
          return {
                  _0: prev._0,
                  _1: prev._1,
                  _2: selectedColor,
                  _3: prev._3
                };
        });
  };
  var set3 = function (param) {
    setCurrentGuess(function (prev) {
          return {
                  _0: prev._0,
                  _1: prev._1,
                  _2: prev._2,
                  _3: selectedColor
                };
        });
  };
  var allSelected = currentGuess._0 !== undefined && currentGuess._1 !== undefined && currentGuess._2 !== undefined ? currentGuess._3 !== undefined : false;
  return JsxRuntime.jsxs("div", {
              children: [
                JsxRuntime.jsx("div", {
                      children: allSelected ? JsxRuntime.jsx("button", {
                              children: " OK ",
                              className: "text-center text-white text-lg mx-auto border py-0 px-2",
                              disabled: !allSelected,
                              onClick: (function (param) {
                                  var guess = Core__Array.keepSome(Mincomind.Guess.toArray(currentGuess));
                                  mincomind.write.addGuess([guess]);
                                })
                            }) : JsxRuntime.jsx("p", {
                              children: "Select colors",
                              className: "text-white text-center text-xxs leading-tight"
                            }),
                      className: "w-16 grid  text-center"
                    }),
                JsxRuntime.jsxs("div", {
                      children: [
                        JsxRuntime.jsx("div", {
                              className: "border h-10 w-10 drop-shadow-md rounded-full " + getOptBgColor(currentGuess._0),
                              onClick: set0
                            }),
                        JsxRuntime.jsx("div", {
                              className: "border h-10 w-10 drop-shadow-md rounded-full " + getOptBgColor(currentGuess._1),
                              onClick: set1
                            }),
                        JsxRuntime.jsx("div", {
                              className: "border h-10 w-10 drop-shadow-md rounded-full " + getOptBgColor(currentGuess._2),
                              onClick: set2
                            }),
                        JsxRuntime.jsx("div", {
                              className: "border h-10 w-10 drop-shadow-md rounded-full " + getOptBgColor(currentGuess._3),
                              onClick: set3
                            })
                      ],
                      className: "flex gap-1 justify-between p-1 mx-auto"
                    })
              ],
              className: "bg-blue-400 flex items-center border w-full"
            });
}

var GuessCreator = {
  make: Game$GuessCreator
};

function Game$ColorSelector(props) {
  var setSelectedColor = props.setSelectedColor;
  var selectedColor = props.selectedColor;
  var colors = [
    0,
    1,
    2,
    3,
    4,
    5
  ];
  var getBgColor$2 = function (c) {
    var bgColor = getBgColor(c);
    if (c === selectedColor) {
      return bgColor + " brightness-75 border border-2 border-white";
    } else {
      return bgColor;
    }
  };
  return JsxRuntime.jsxs("div", {
              children: [
                JsxRuntime.jsx("div", {
                      children: colors.map(function (c, i) {
                            return JsxRuntime.jsx("div", {
                                        className: " h-10 w-10 drop-shadow-md rounded-full " + getBgColor$2(c) + " pointer hover:brightness-20 ",
                                        onClick: (function (param) {
                                            setSelectedColor(function (param) {
                                                  return c;
                                                });
                                          })
                                      }, i.toString());
                          }),
                      className: "flex gap-1 justify-between p-2"
                    }),
                JsxRuntime.jsx("p", {
                      children: "Click a colour, then click on a circle to select",
                      className: "text-white text-center text-xs leading-tight"
                    })
              ],
              className: "flex flex-col items-center w-full"
            });
}

var ColorSelector = {
  make: Game$ColorSelector
};

function Game$EmptyRow(props) {
  return JsxRuntime.jsxs("div", {
              children: [
                JsxRuntime.jsx("div", {
                      children: Core__Array.make(4, undefined).map(function (param, i) {
                            return JsxRuntime.jsx("div", {
                                        className: "border h-5 rounded-full " + getBgColor$1(undefined)
                                      }, i.toString());
                          }),
                      className: "w-14 grid grid-cols-2 gap-1 border p-1"
                    }),
                JsxRuntime.jsxs("div", {
                      children: [
                        JsxRuntime.jsx("div", {
                              children: (8 - props.index | 0).toString(),
                              className: "text-white opacity-40 pr-4"
                            }),
                        Core__Array.make(4, 0).map(function (_c, i) {
                              return JsxRuntime.jsx("div", {
                                          className: "border h-10 w-10 drop-shadow-md rounded-full bg-black opacity-25"
                                        }, i.toString());
                            })
                      ],
                      className: "flex gap-1 mx-auto items-center p-2"
                    })
              ],
              className: "bg-blue-300 flex items-center border w-full"
            });
}

var EmptyRow = {
  make: Game$EmptyRow
};

function makeGuess(guess, cows, bulls) {
  return Core__Result.map(make(bulls, cows), (function (cowsAndBulls) {
                return {
                        guess: guess,
                        cowsAndBulls: cowsAndBulls
                      };
              }));
}

function resultToOption(result) {
  if (result.TAG === "Ok") {
    return Caml_option.some(result._0);
  }
  
}

var mockGuesses = Core__Array.filterMap([
      makeGuess(Mincomind.Guess.make(4, 0, 1, 2), 1, 1),
      makeGuess(Mincomind.Guess.make(5, 0, 2, 3), 2, 0),
      makeGuess(Mincomind.Guess.make(4, 4, 1, 1), 0, 3)
    ], resultToOption);

function Game$Game(props) {
  var mincomind = props.mincomind;
  var gameId = props.gameId;
  var user = props.user;
  var match = React.useState(function () {
        return 0;
      });
  var selectedColor = match[0];
  var game = ContractHooks.useGame(user, gameId, mincomind);
  if (typeof game !== "object") {
    return "Loading game " + gameId.toString() + "...";
  }
  if (game.TAG === "Err") {
    return "Error loading game...";
  }
  var game$1 = game._0;
  var guesses = game$1.guesses.filter(function (_item, index) {
        return index < game$1.numGuesses;
      });
  return JsxRuntime.jsxs("div", {
              children: [
                JsxRuntime.jsx(Game$SolutionRow, {}),
                Core__Array.make(8 - game$1.numGuesses | 0, 0).map(function (_0, index) {
                      return JsxRuntime.jsx(Game$EmptyRow, {
                                  index: index
                                });
                    }),
                guesses.map(function (guess, index) {
                          return [
                                  Mincomind.Guess.fromArrayUnsafe(guess),
                                  index
                                ];
                        }).toReversed().map(function (param) {
                      var i = param[1];
                      return JsxRuntime.jsx(Game$GuessRow, {
                                  guess: param[0],
                                  attempt: i,
                                  user: user,
                                  gameId: gameId,
                                  mincomind: mincomind
                                }, i.toString());
                    }),
                JsxRuntime.jsx(Game$GuessCreator, {
                      selectedColor: selectedColor,
                      mincomind: mincomind
                    }),
                JsxRuntime.jsx(Game$ColorSelector, {
                      selectedColor: selectedColor,
                      setSelectedColor: match[1]
                    })
              ]
            });
}

var Game = {
  make: Game$Game
};

function Game$1(props) {
  var mincomind = props.mincomind;
  var user = props.user;
  var latestGameId = ContractHooks.useLatestGameId(user, mincomind);
  var tmp;
  tmp = typeof latestGameId !== "object" ? "Checking latest game..." : (
      latestGameId.TAG === "Err" ? "Error checking latest game..." : JsxRuntime.jsx(Game$Game, {
              user: user,
              gameId: latestGameId._0,
              mincomind: mincomind
            })
    );
  return JsxRuntime.jsx("div", {
              children: tmp,
              className: "flex flex-col items-center max-w-md mx-auto rounded px-8"
            });
}

var make$1 = Game$1;

export {
  loadDataHack ,
  getBgColor ,
  CowsAndBulls ,
  SolutionRow ,
  CluePegs ,
  GuessRow ,
  GuessCreator ,
  ColorSelector ,
  EmptyRow ,
  makeGuess ,
  resultToOption ,
  mockGuesses ,
  Game ,
  make$1 as make,
}
/* mockGuesses Not a pure module */
