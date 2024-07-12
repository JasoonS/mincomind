import {
  GameContract,
  PotContract,
  PlayerEntity,
  TournamentEntity,
} from "generated";

const TournamentID = "mincomind";
const gameDepositAmount = BigInt(1); // todo: set once its known

// - event: GameStarted(address player)
GameContract.GameStarted.handler(async ({ event, context }) => {
  let player: PlayerEntity | undefined = await context.Player.get(
    event.params.player
  );

  // new player, so create
  if (player === undefined) {
    context.player.set({
      id: event.params.player,
      points: BigInt(0),
      numberOfGames: 0,
      active: true,
    });
  }
  // player already exists, so update
  else {
    context.player.set({
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
    context.tournament.set({
      id: TournamentID,
      pot: gameDepositAmount,
    });
  } else {
    context.tournament.set({
      ...tournament,
      pot: tournament.pot + gameDepositAmount,
    });
  }
});

// - event: GameOutcome(address player, uint32 points) - 0 points implies the player didn't solve the game
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
    context.player.set({
      ...player,
      points: player.points + BigInt(event.params.points),
    });
  }
});

// - event: FundsWithdrawn(address player, uint32 amount)
PotContract.FundsWithdrawn.handler(async ({ event, context }) => {
  let player: PlayerEntity | undefined = await context.Player.get(
    event.params.player
  );

  // this shouldnt be possible
  if (player === undefined) {
    context.log.error("Player not found");
  }
  // player has withdrawn all funds, so deactivate
  else {
    context.player.set({
      ...player,
      points: BigInt(0),
      active: false,
    });
  }
});
