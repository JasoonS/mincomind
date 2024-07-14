import React from 'react';
import { useSubscription, gql } from '@apollo/client';
import { getAddress } from 'viem';

const usersGameSubscription = (userAddress) => gql`
  subscription MySubscription {
    Game(
      order_by: {gameId: desc_nulls_last}
      limit: 1
      where: {player: {_eq: "${userAddress}"}}
    ) {
      player
      gameId
    }
  }
`;

const gameGuessesSubscription = (gameId, userAddress) => gql`
  subscription MyGuessSubscription {
    Guess(
      where: {gameId: {_eq: "${gameId}"}, player: {_eq: "${userAddress}"}}
      order_by: {attempt: asc}
    ) {
      gameId
      gameIdLink
      guessPos0
      guessPos1
      guessPos2
      guessPos3
      hintBulls
      hintCows
      player
      id
      attempt
    }
  }
`;

const GetGuesses = ({ displayChildComponentFunction, gameId, usersAddress }) => {
  console.log("<inside> CHILD COMPONENT", displayChildComponentFunction);

  const { data, loading, error } = useSubscription(gameGuessesSubscription(gameId, usersAddress));

  if (loading) return <div>{displayChildComponentFunction([])}</div>;
  if (error) return <p>Error: {error.message}</p>;

  return displayChildComponentFunction(data);
};

export function loadDataHackHack(usersAddress, displayChildComponentFunction) {
  console.log("CHILD COMPONENT", displayChildComponentFunction);

  const userAddress = getAddress(usersAddress);
  const { data, loading, error } = useSubscription(usersGameSubscription(userAddress));
  console.log("data", data);

  const latestGame = data?.Game?.[0];

  if (loading) return <p>Loading...</p>;
  if (error) return <p>Error: {error.message}</p>;
  if (!latestGame) {
    return <p>No game found for this user.</p>;
  }

  const { gameId } = latestGame;

  return (
    <GetGuesses
      displayChildComponentFunction={displayChildComponentFunction}
      usersAddress={userAddress}
      gameId={gameId}
    />
  );
}
