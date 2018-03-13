# Games

In all games, there are some variables used to gather as much information about given game as user provides, e.g. scenarios played, classes, expansions etc.

Due to those being saved in game object when creating a new game, it is now much simpler to show correct information. For exmaple, if there is expansionsArray in game, then it will display additional textView when creating a new match, so it is much simpler to add new games. There is now no need to write game-specific segues and information.

As all of those values are optional, it is easy to indicate that given game doesn't have such things, e.g. game has no player classes or expansions yet.

### pointsExtendedNameArray -> [String]?

In some games calculation of points is more complicated, i.e. there are a few categories used. Name of those categories should be listed inside this array.

### professionsArray - [String]?

Array of all starting professions names that are used in this game.

### expansionsArray - [String]?

Array of all available expansions.

### areExpansionsMultiple -> Bool?

Indicates if player can choose multiple expansions.

### scenariosArray - [String]?

Array of all available scenarios.

### areScenariosMultiple -> Bool?

Indicates if player can choose multiple scenarios.

### evilProfessionsArray -> [String]?; goodProfessionsArray -> [String]?

In some games, such as mafia-style ones, there are evil and good classes. If so, then it will generate additional statistics about win-ratio for good and bad guys.

### winSwitch -> Bool

Indicates if there is winSwitch (almost always there is in cooperation games)

### difficultyNames -> [String]?

Array of difficulty names, e.g. ["Easy", "Medium", "Hard"].

### roundsLeftName -> String?

In many games we can see how good were the match according to some game-specific events left. For example - in Robinson Crusoe more days are left after completing scenario means better match. Or in Pandemic - cards left in stack indicates how good team was. In case of RobinsonCrusoe the roundsLeftName should be "Days" and in case of Pandemic - "Cards"

### additionalSwitchName -> String

Name of additional switch that can be introduced to game. For example - if game was finished by being killed by Assassin.

## dictionary -> [String: Any]?

There is sometimes more information that can be used laster in statistics and they can be added here. They need to be casted down to type given below.

### Pandemic

| Query(key) | Value type | Return description |
| --- | --- | --- |
"DiseasesName" | [String] | Array of all Disease names.
"DiseasesCure" | [String] | Array of all Disease cure statuses available.

### Robinson Crusoe

| Query(key) | Value type | Return description |
| --- | --- | --- |
"Points" | Int | Player points for this game


## Authors

* **Przemyslaw Szafulski**
