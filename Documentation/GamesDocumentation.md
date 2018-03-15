# Games

In all games, there are some variables used to gather as much information about given game as user provides, e.g. scenarios played, classes, expansions etc.

Due to those being saved in game object when creating a new game, it is now much simpler to show correct information. For exmaple, if there is expansionsArray in game, then it will display additional textView when creating a new match, so it is much simpler to add new games. There is now no need to write game-specific segues and information.

As all of those values are optional, it is easy to indicate that given game doesn't have such things, e.g. game has no player classes or expansions yet.

### pointsExtendedNameArray: [String]?

In some games calculation of points is more complicated, i.e. there are a few categories used. Name of those categories should be listed inside this array.

As an example - in 7 Wonders it should be "War", "Knowledge", "Wonder", "Leaders" etc.

### classesArray: [String]?

Array of all starting classes names that are used in this game.

### goodClassesArray, evilClassesArray: [String]?

In some games there is distinction between good and evil classes. If so, they should be listed here.

There is no need to put all classes in classesArray then. Putting good and evil classes is sufficient.

### expansionsArray: [String]?

Array of all available expansions.

### areExpansionsMultiple: Bool?

Indicates if player can choose multiple expansions.

### scenariosArray: [String]?

Array of all available scenarios.

### areScenariosMultiple: Bool?

Indicates if player can choose multiple scenarios.

### winSwitch: Bool

Indicates if there is winSwitch (almost always there is in cooperation games)

### difficultyNames: [String]?

Array of difficulty names, e.g. ["Easy", "Medium", "Hard"].

### roundsLeftName: String?

In many games we can see how good were the match according to some game-specific rounds left.

For example - in Robinson Crusoe the more days are left after completing scenario the better match.
In Pandemic - cards left in stack indicates how good team was.

In case of RobinsonCrusoe the roundsLeftName should be "Days" and in case of Pandemic - "Cards"

### additionalSwitchName, additionalSecondSwitchName: String

Name of additional switch that can be introduced to game.

For example - if game was finished by being killed by Assassin. Then then additionalSwitchName should be set to "Killed by Assassin"


## Authors

* **Przemyslaw Szafulski**
