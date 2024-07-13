import {
  GameContract,
  PlayerEntity,
  TournamentEntity,
  GameEntity,
} from "generated";

const TournamentID = "mincomind";
const gameDepositAmount = BigInt(1); // todo: set once its known

// - event: NewGame(address indexed player, uint32 gameId)
GameContract.NewGame.handler(async ({ event, context }) => {
  let player: PlayerEntity | undefined = await context.Player.get(
    event.params.player
  );

  // new player, so create
  if (player === undefined) {
    context.Player.set({
      id: event.params.player,
      points: BigInt(0),
      numberOfGames: 0,
      active: true,
    });
  }
  // player already exists, so update
  else {
    context.Player.set({
      ...player,
      numberOfGames: player.numberOfGames + 1,
      active: true,
    });
  }

  // create tournament if it doesn't exist
  let tournament: TournamentEntity | undefined = await context.Tournament.get(
    TournamentID
  );

  if (tournament === undefined) {
    context.Tournament.set({
      id: TournamentID,
      pot: gameDepositAmount,
    });
  } else {
    context.Tournament.set({
      ...tournament,
      pot: tournament.pot + gameDepositAmount,
    });
  }
});

// - event: GameOutcome(address indexed player, uint32 gameId, uint8 points) - 0 points implies the player didn't solve the game
GameContract.GameOutcome.handler(async ({ event, context }) => {
  let player: PlayerEntity | undefined = await context.Player.get(
    event.params.player
  );

  // this shouldnt be possible
  if (player === undefined) {
    context.log.error("Player not found");
  }
  // update players points
  else {
    context.Player.set({
      ...player,
      points: player.points + BigInt(event.params.points),
    });
  }
});

// - event: FundsWithdrawn(address player, uint256 amount)
GameContract.FundsWithdrawn.handler(async ({ event, context }) => {
  let player: PlayerEntity | undefined = await context.Player.get(
    event.params.player
  );

  // this shouldnt be possible
  if (player === undefined) {
    context.log.info("Someone wasting gas to withdraw no funds");
  }
  // player has withdrawn all funds, so deactivate
  else {
    context.Player.set({
      ...player,
      points: BigInt(0),
      active: false,
    });
  }
});

// - event: GuessAdded(address indexed player, uint32 gameId, uint8 numGuesses, uint8[4] guess)
GameContract.GuessAdded.handler(async ({ event, context }) => {
  let game: GameEntity | undefined = await context.Game.get(
    event.params.player + "-" + event.params.gameId
  );

  context.Guess.set({
    id:
      event.params.player +
      "-" +
      event.params.gameId +
      "-" +
      event.params.numGuesses,
    gameIdLink: event.params.player + "-" + String(event.params.gameId),
    player: event.params.player,
    gameId: String(event.params.gameId),
    attempt: Number(event.params.numGuesses),
    guessPos0: Number(event.params.guess[0]),
    guessPos1: Number(event.params.guess[1]),
    guessPos2: Number(event.params.guess[2]),
    guessPos3: Number(event.params.guess[3]),
    hintBulls: Number(event.params.bulls),
    hintCows: Number(event.params.cows),
  });

  // if undefined, create new game
  if (game === undefined) {
    context.Game.set({
      id: event.params.player + "-" + event.params.gameId,
      player: event.params.player,
      gameId: String(event.params.gameId),
    });
  }
});
