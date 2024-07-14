# MincoMind

On chain cows and bulls tournament built on Inco network, leveraging fully homomorphic encryption to enable secret values and randomisation in smart contracts.

> Commonly known as [Mastermind](<https://en.wikipedia.org/wiki/Mastermind_(board_game)>)

- [Contract deployment](https://explorer.testnet.inco.org/address/0x7DA25264C70EDD4944D5Ea2F163E2702c277f4e5?tab=contract)

## Game play

### Basics

- A game is started and there is a secret combination of 4 pegs randomly ordered and coloured from 6 different colours.
- A player tries to guess the code by placing a sequence of 4 colored pegs.
- After each guess, the player gets feedback:
  - A black peg for each correct color in the correct position (bull).
  - A white peg for each correct color in the wrong position (cow).
- Objective: The player uses the feedback to deduce the secret code within 8 attempts.

### Tournament

- Each player is required to deposit 0.0001 inco per game, this goes into a pot.
- Should the player be unable to solve the puzzle within 8 attempts they forfeit their deposit.
- If the player successfully solves the puzzle, they receive points and appear on the leaderboard
- Points can be redeemed proportionally to the inco in the pot.

  ![points redemption](./assets/points-redemption.png)

  where:

  - \( x \) is the withdrawable amount
  - \( y \) is the users points
  - \( z \) is the total points of all users
  - \( v \) is the total deposits in the pot

- If a user redeems their points they are removed from the leaderboard.
- Points are calculated as follows

  ![points per game](./assets/points-per-game.png)

  where:

  - \( p \) is the points
  - \( n \) is the total possible attempts (in this case, \( n = 8 \))
  - \( a \) is the number of attempts needed to solve the puzzle

- Finally, a users total points are the sum of their points from each game.

  ![total points](./assets/total-points.png)

  where:

  - \( y \) is the sum of all game points
  - \( pi \) is the points from the \( i \)-th game
  - \( k \) is the total number of games played
