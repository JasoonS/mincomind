// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";
import * as Pagination from "./Pagination.res.mjs";
import * as JsxRuntime from "react/jsx-runtime";

function Table$Row(props) {
  var player = props.player;
  return JsxRuntime.jsxs("tr", {
              children: [
                JsxRuntime.jsx("td", {
                      children: player.address,
                      className: "py-1 px-3 text-left"
                    }),
                JsxRuntime.jsx("td", {
                      children: player.numberOfGamesPlayed.toString(),
                      className: "py-1 px-3 text-left"
                    }),
                JsxRuntime.jsx("td", {
                      children: player.points.toString(),
                      className: "py-1 px-3 text-left"
                    }),
                JsxRuntime.jsx("td", {
                      children: "$",
                      className: "py-1 px-3 text-left"
                    })
              ],
              className: props.rowStyle
            });
}

var Row = {
  make: Table$Row
};

function Table$TableInner(props) {
  return JsxRuntime.jsx("div", {
              children: JsxRuntime.jsxs("table", {
                    children: [
                      JsxRuntime.jsx("thead", {
                            children: JsxRuntime.jsxs("tr", {
                                  children: [
                                    JsxRuntime.jsx("th", {
                                          children: "Player",
                                          className: "py-3 px-6 text-left"
                                        }),
                                    JsxRuntime.jsx("th", {
                                          children: "#No of Games",
                                          className: "py-3 px-6 text-left"
                                        }),
                                    JsxRuntime.jsx("th", {
                                          children: "Points",
                                          className: "py-3 px-6 text-left"
                                        }),
                                    JsxRuntime.jsx("th", {
                                          children: "Inco earned",
                                          className: "py-3 px-6 text-left"
                                        })
                                  ]
                                }),
                            className: "m-10 text-xs bg-black"
                          }),
                      JsxRuntime.jsx("tbody", {
                            children: props.players.map(function (player, index) {
                                  return JsxRuntime.jsx(Table$Row, {
                                              player: player,
                                              rowStyle: index % 2 === 0 ? "bg-white bg-opacity-10" : ""
                                            }, player.address);
                                })
                          })
                    ],
                    className: "text-white border rounded border-2 border-primary p-2 m-2 bg-black bg-opacity-30"
                  })
            });
}

var TableInner = {
  make: Table$TableInner
};

function Table$TableOuter(props) {
  var players = props.players;
  var match = React.useState(function () {
        return 0;
      });
  var setPage = match[1];
  var page = match[0];
  return JsxRuntime.jsxs("div", {
              children: [
                JsxRuntime.jsx(Table$TableInner, {
                      players: players,
                      page: page,
                      pageSize: 10
                    }),
                JsxRuntime.jsx(Pagination.make, {
                      activePage: page + 1 | 0,
                      numPages: (players.length / 10 | 0) - 1 | 0,
                      onChange: (function (newPage) {
                          setPage(function (param) {
                                return newPage - 1 | 0;
                              });
                        })
                    })
              ],
              className: "overflow-x-auto"
            });
}

var TableOuter = {
  make: Table$TableOuter
};

function Table(props) {
  var dummyData = [
    {
      address: "0x1234",
      points: 19,
      numberOfGamesPlayed: 12
    },
    {
      address: "0x2345",
      points: 12,
      numberOfGamesPlayed: 14
    },
    {
      address: "0x43112",
      points: 10,
      numberOfGamesPlayed: 8
    },
    {
      address: "0x4123",
      points: 7,
      numberOfGamesPlayed: 7
    },
    {
      address: "0x14215",
      points: 2,
      numberOfGamesPlayed: 2
    }
  ];
  return JsxRuntime.jsx("div", {
              children: JsxRuntime.jsx("div", {
                    children: JsxRuntime.jsx(Table$TableOuter, {
                          players: dummyData
                        }),
                    className: "flex flex-col items-center justify-center h-screen m-0 p-0 text-primary overflow-y-hidden overflow-x-hidden"
                  })
            });
}

var make = Table;

export {
  Row ,
  TableInner ,
  TableOuter ,
  make ,
}
/* react Not a pure module */
