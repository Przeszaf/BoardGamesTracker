# Custom Matches

In custom matches there are variables used for many of games, but in each game they have different meaning. This documentation explains meaning of those variables in custom games created so far.

Two types of variables are used in custom matches:

## playersClasses

playersClasses is a dictionary [String: Any] that holds playerID as a key (string) and given game professions/classes as value. It needs to be casted down to be useful.

Used to get information about profession that was chosen by/assigned to a given player.

## dictionary

dictionary is of type [String: Any] that hold queries specific to given games as keys and Anything as value.

It is used to retrieve such information as game-specific events happening, expansions used during given game etc.

### Avalon

playersClasses needs to be casted down to [String: AvalonClasses]

Dictionary queries:

| Query | Value type | Description |
| --- | --- | --- |
"Killed by Assassin?" | Bool | At the end of game, if Servants of Arthur wins, Minions of Mordred have one last chance - they have to kill Merlin. If they do so, then they win, if not - then Good side wins.
"Lady of the lake?" | Bool | Lady of the lake is additional event that can be introduced to a game.

### Pandemic

playersClasses needs to be casted down to [String: PandemicClasses]

Dictionary queries:

| Query | Value type | Description |
| --- | --- | --- |
"Cards left" | Int | Amount of cards left. Bigger = better, as it means that players had more time available.
"Difficulty" | String | Either one of "Easy (4 Epidemy cards)", "Medium (5 Epidemy cards)", "Hard (6 Epidemy cards)"
"Diseases" | [String: String] | Dictionary of all disease name with cureStatus

#### "Diseases" dictionary

Available disease names (keys):

- "Red"
- "Blue"
- "Yellow"
- "Green"

Available cure statuses (values):

- "Not cured"
- "Cured"
- "Elliminated"

### Carcassonne

There are no playersClassess in Carcassonne

Dictionary queries:

| Query | Value type | Description |
| --- | --- | --- |
"Expansions" | [String] | Returns all expansions that were used in this match of Carcassonne. All available expansions can be checked at /Models/Enums/Expansions.swift

## Authors

* **Przemyslaw Szafulski**
