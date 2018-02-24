# Custom Matches

In custom matches there are variables used for many of games, but in each game they have different meaning. This documentation explains meaning of those variables in custom games created so far.

Two types of variables are used in custom matches:

## playersClasses

playersClasses is a dictionary [String: Any] that holds playerID as a key (string) and given game professions/classes as value. It needs to be casted down to be useful.

Used to get information about profession that was chosen by/assigned to a given player.

## dictionary

dictionary is of type [String: Any] that hold queries specific to given games as keys and Anything as value.

It is used to retrieve such information as game-specific events happening, expansions used during given game etc.


## Avalon

playersClasses needs to be casted down to [String: AvalonClasses]

Dictionary queries:

| Query | Value type | Description |
| --- | --- | --- |
"Killed by Assassin?" | Bool | At the end of game, if Servants of Arthur wins, Minions of Mordred have one last chance - they have to kill Merlin. If they do so, then they win, if not - then Good side wins.
"Lady of the lake?" | Bool | Lady of the lake is additional event that can be introduced to a game.


## Authors

* **Przemyslaw Szafulski**
