# Matches

In matches there is a dictionary that holds many additional information about the games if available. Here all possible values of dictionary are discussed.

## dictionary

dictionary is of type [String: Any]

It is used to retrieve such information as game-specific events happening, expansions used during given game etc. It can be checked if they are available by checking if given game variables are to nil or not.

For example - if there are classes in given game, then the game's variable classesArray will be set to some string array (it won't be nil). Then we can use the dictionary in match to check players classes.

As the dictionary is of type [String: Any], then it needs to be casted down to type given below in table below.

Dictionary queries:

Game variable | Dictionary query | Value type | Description |
| --- | --- | --- | --- |
pointsExtendedNameArray | "Points?" | [String: [Int]] | Dictionary that holds **playerID** as key and extended points array as value.
classesArray | "Classes" | [String: String] | Dictionary that holds **playerID** as key and player's class as value. Note - if there are goodClassesArray and evilClassesArray set in game, then additional graph can be made
expansionsArray | "Expansions" | [String] | Array of expansions used in this match
scenariosArray | "Scenarios" | [String] | Array of scenarios used in this match
difficultyNames | "Difficulty" | String | Difficulty of match
winSwitch | "Win" | Bool | Indicates if given match was won or lost (used mostly in cooperation games)
roundsLeftName | "Rounds left" | Int | How many rounds (or days, cards) were left after finishing the match.
additionalSwitchName | additionalSwitchName | Bool | Some game-specific event happening or not.
additionalSecondSwitchName | additionalSecondSwitchName | Bool | Some game-specific event happening or not.


## Authors

* **Przemyslaw Szafulski**
