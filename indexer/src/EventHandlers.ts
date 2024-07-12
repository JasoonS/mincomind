import { GameContract, PotContract, PlayerEntity } from "generated";

// - event: GameStarted(address player)
GameContract.GameStarted.handler(({ event, context }) => {
  let player: PlayerEntity | undefined = context.Player.get(
    event.params.player.toHex()
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
});

// - event: GameOutcome(address player, uint32 points) - 0 points implies the player didn't solve the game
GameContract.GameOutcome.handler(({ event, context }) => {
  let player: PlayerEntity | undefined = context.Player.get(
    event.params.player.toHex()
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
PotContract.FundsWithdrawn.handler(({ event, context }) => {
  let player: PlayerEntity | undefined = context.Player.get(
    event.params.player.toHex()
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
