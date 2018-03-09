# Custom Matches

In custom matches there are variables used for many of games, but in each game they have different meaning. This documentation explains meaning of those variables in custom games created so far.

Two types of variables are used in custom matches:

### playersClasses

playersClasses is a dictionary [String: String] that holds playerID as a key (string) and given game professions/classes as value.

Used to get information about profession that was chosen by/assigned to a given player.

All profession are listed under structs inside /Models/Other/Professions.swift file.

### dictionary

dictionary is of type [String: Any] that hold queries specific to given games as keys and Anything as value.

It is used to retrieve such information as game-specific events happening, expansions used during given game etc.

## Avalon

Players classes available:

Lawful: Loyal Servant of Arthur, Merlin, Percival

Evil: Minion of Morder, Assassin, Morgana, Mordred, Oberon

Dictionary queries:

| Query | Value type | Description |
| --- | --- | --- |
"Killed by Assassin?" | Bool | At the end of game, if Servants of Arthur wins, Minions of Mordred have one last chance - they have to kill Merlin. If they do so, then they win, if not - then Good side wins.
"Lady of the lake?" | Bool | Lady of the lake is additional event that can be introduced to a game.

## Pandemic

Players classes available:

Dispatcher, Scientist, Quarantine Specialist, Researcher, Medic, Contigency Planner

Dictionary queries:

| Query | Value type | Description |
| --- | --- | --- |
"Cards left" | Int | Amount of cards left. Bigger = better, as it means that players had more time available.
"Difficulty" | String | Either one of "Easy (4 Epidemy cards)", "Medium (5 Epidemy cards)", "Hard (6 Epidemy cards)"
"Diseases" | [String: String] | Dictionary of all disease name with cureStatus

### "Diseases" dictionary

Available disease names (keys):

- "Red"
- "Blue"
- "Yellow"
- "Green"

Available cure statuses (values):

- "Not cured"
- "Cured"
- "Elliminated"

## Carcassonne

Dictionary queries:

| Query | Value type | Description |
| --- | --- | --- |
"Expansions" | [String] | Returns all expansions that were used in this match of Carcassonne. All available expansions are listed at /Models/Other/Expansions.swift


## Codenames

Dictionary queries:

| Query | Value type | Description |
| --- | --- | --- |
"Assassin?" | Bool | Indicates if game was ended by choosing Assassin
"Cards left" | Int | How many cards opponent had left. Smaller amount means opponent was closer to win.

## 7 Wonders

Player classes (starting cities) available:

Rome, Alexandria, Olympia, ...

Dictionary queries:

| Query | Value type | Description |
| --- | --- | --- |
Points | [String: [Int]] | Returns dictionary with playerID as key and integer Array as value.

### "Points" dictionary

[Int] is points array with following meaning for each itemand

| [0] | [1] | [2] | [3] | [4] | [5] | [6] | [7] |
| --- | --- | --- | --- | --- | --- | --- | --- |
| War | Knowledge | Other | Other | Other | Other | Other | Leaders |

## Authors

* **Przemyslaw Szafulski**
