//
//  AllMatchesViewController.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 22/01/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//

import UIKit
import CoreData

class GameDetailsViewController: UITableViewController {

    var game: Game!
    var matches: [Match]!
    var managedContext: NSManagedObjectContext!
    var tableHeaderView: GameDetailsHeaderView!


    //MARK: - Overriding functions
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        reloadHeaderView()

        tableView.backgroundColor = Constants.Global.backgroundColor
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        managedContext = appDelegate.persistentContainer.viewContext

        let dateSortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        
        matches = game.matches?.sortedArray(using: [dateSortDescriptor]) as! [Match]
        //Register cell and create button item
        tableView.register(SelectedGameMatchesCell.self, forCellReuseIdentifier: "SelectedGameMatchesCell")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(toggleEditingMode(_:)))
    }


    //MARK: - UITableView

    //Conforming to UITableViewDataSource protocol
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectedGameMatchesCell") as! SelectedGameMatchesCell

        cell.dateLabel.text = matches[indexPath.row].date?.toStringWithHour()

        let match = matches[indexPath.row]
        
        let players = match.players?.allObjects as! [Player]
        
        cell.playersLabel.text = playersToString(game: game, match: match, players: players)

        cell.backgroundColor = UIColor.clear
        if isEditing {
            cell.backgroundView = CellBackgroundEditingView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: cell.frame.height))
        } else {
            cell.backgroundView = CellBackgroundView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: cell.frame.height))
        }

        cell.selectionStyle = .none
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matches.count
    }


    //Setting correct height of row
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let match = matches[indexPath.row]
        let players = match.players?.allObjects as! [Player]
        let string = playersToString(game: game, match: match, players: players)
        let height = string.height(withConstrainedWidth: view.frame.width - 25, font: UIFont.systemFont(ofSize: 17)) + 28
        if height > 44 {
            return height
        }
        return 44
    }

    //Assigns backgroundView, because cell height might be different than when initialising cell.
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundView = CellBackgroundView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: cell.frame.height))
    }


    //Deletions
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let match = matches[indexPath.row]
            let title = "Are you sure you want to delete 1 match of \(match.game!.name!)?"
            let alert = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
                Helper.removeMatch(match: match)
                self.matches.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            })
            alert.addAction(deleteAction)
            present(alert, animated: true, completion: nil)
        }
    }


    //Sets correct background views for cell
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        cell.backgroundView = CellBackgroundSelectView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: cell.frame.height))
    }

    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        cell.backgroundView = CellBackgroundView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: cell.frame.height))
    }

    override func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        cell.backgroundView = CellBackgroundHighlightView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: cell.frame.height))
    }

    override func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        cell.backgroundView = CellBackgroundView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: cell.frame.height))
    }

    //MARK: - Buttons

    //Button set to toggle editing mode
    @IBAction func toggleEditingMode(_ sender: UIBarButtonItem) {
        if isEditing {
            setEditing(false, animated: true)
            sender.title = "Edit"
            tableView.reloadData()
        } else {
            setEditing(true, animated: true)
            sender.title = "Done"
            tableView.reloadData()
        }
    }


    //MARK: - Other

    //Getting string to put into playersField. Depends on game type.
    func playersToString(game: Game, match: Match, players: [Player]) -> String {
        var pointsDict = [Player: Int]()
        var placesDict = [Player: Int]()
        for playerResult in match.results?.allObjects as! [PlayerResult] {
            pointsDict[playerResult.player!] = Int(playerResult.point)
            placesDict[playerResult.player!] = Int(playerResult.place)
        }
        let sortedPlayers = players.sorted(by: {placesDict[$0]! < placesDict[$1]!})
        
        
        var stringArray = [String]()
        for (i, player) in sortedPlayers.enumerated() {
            if game.type == GameType.SoloWithPoints {
                stringArray.append("\(player.name!): \(pointsDict[player]!)")
            } else if game.type == GameType.SoloWithPlaces {
                stringArray.append("\(placesDict[player]!). \(player.name!)")
            } else if game.type == GameType.TeamWithPlaces {
                if i > 0 {
                    //Detects when players change from winning to losing
                    if placesDict[sortedPlayers[i-1]]! == 1 && placesDict[player]! == 2 {
                        stringArray.append("\nLosers: \(player.name!)")
                    } else {
                        stringArray.append("\(player.name!)")
                    }
                } else {
                    stringArray.append("Winners: \(player.name!)")
                }
            } else if game.type == GameType.Cooperation {
                stringArray.append("\(player.name!)")
            }
        }
        var string = stringArray.joined(separator: ", ")

        //Delete coma after all winners
        string = string.replacingOccurrences(of: ", \n", with: "\n")
        return string
    }

    func reloadHeaderView() {

        if matches.isEmpty {
            return
        }

        var headerViews = [UIView]()

        //Creating game statistics view
        var height: CGFloat = 90
        if game.type == GameType.SoloWithPoints {
            height = 100
        } else {
            height = 65
        }
        let gameStatisticsView = GameDetailsHeaderView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: height))


        //Add info about total matches
        gameStatisticsView.totalMatchesLabel.text = "Total matches: \(matches.count)"

        gameStatisticsView.totalPlayersLabel.text = "Total players: \(game.players?.count ?? 0)"

        //Get total and average time of match
        let (totalTime, averageTime) = { () -> (TimeInterval, Double) in
            var time: TimeInterval = 0
            var count: Double = 0
            for match in matches {
                time += match.time
                if match.time != 0 {
                    count += 1
                }
            }
            if count == 0 {
                return (0, 0)
            }
            return (time, time/count)
        }()
        
        gameStatisticsView.totalTimePlayedLabel.text = "Total time played: \(totalTime.toString())"
        gameStatisticsView.averageTimePlayedLabel.text = "Average time of match: \(averageTime.toString())"

        //For SoloWithPoints game display more information
        if game.type == GameType.SoloWithPoints && game.matches?.anyObject() != nil {
            gameStatisticsView.maxPointsLabel.isHidden = false
            gameStatisticsView.minPointsLabel.isHidden = false
            gameStatisticsView.averageWinningPointsLabel.isHidden = false
            gameStatisticsView.averagePointsLabel.isHidden = false
            
            
            
            //Using fetching to get min, max, average and averageWinning points
            
            let keypathExpression = NSExpression(forKeyPath: "point")
            let maxExpression = NSExpression(forFunction: "max:", arguments: [keypathExpression])
            let minExpression = NSExpression(forFunction: "min:", arguments: [keypathExpression])
            let averageExpression = NSExpression(forFunction: "average:", arguments: [keypathExpression])
            
            let maxExpressionDescription = NSExpressionDescription()
            maxExpressionDescription.expression = maxExpression
            maxExpressionDescription.name = "maxPoint"
            maxExpressionDescription.expressionResultType = .integer32AttributeType
            
            let minExpressionDescription = NSExpressionDescription()
            minExpressionDescription.expression = minExpression
            minExpressionDescription.name = "minPoint"
            minExpressionDescription.expressionResultType = .doubleAttributeType
            
            let averageExpressionDescription = NSExpressionDescription()
            averageExpressionDescription.expression = averageExpression
            averageExpressionDescription.name = "averagePoint"
            averageExpressionDescription.expressionResultType = .doubleAttributeType
            
            let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest()
            request.entity = NSEntityDescription.entity(forEntityName: "PlayerResult", in: managedContext)
            request.resultType = NSFetchRequestResultType.dictionaryResultType
            request.predicate = NSPredicate(format: "%K == %@", #keyPath(PlayerResult.match.game.name), game.name!)
            request.propertiesToFetch = [maxExpressionDescription, minExpressionDescription, averageExpressionDescription]
            
            let requestAverageWinning: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest()
            requestAverageWinning.entity = NSEntityDescription.entity(forEntityName: "PlayerResult", in: managedContext)
            requestAverageWinning.predicate = NSPredicate(format: "%K == %ld AND %K == %@", #keyPath(PlayerResult.place), 1, #keyPath(PlayerResult.match.game.name), game.name!)
            requestAverageWinning.propertiesToFetch = [averageExpressionDescription]
            requestAverageWinning.resultType = .dictionaryResultType
            
            
            do {
                let result = try managedContext.fetch(request) as? [[String: Double]]
                let resultWinning = try managedContext.fetch(requestAverageWinning) as? [[String: Double]]
                if let dict = result?.first {
                    let maxPoints = Int(dict["maxPoint"] ?? 0)
                    let minPoints = Int(dict["minPoint"] ?? 0)
                    gameStatisticsView.maxPointsLabel.text = "Max points: \(maxPoints)"
                    gameStatisticsView.minPointsLabel.text = "Min points: \(minPoints)"
                    let averagePointsString = String.init(format: "%.2f", dict["averagePoint"] ?? 0)
                    gameStatisticsView.averagePointsLabel.text = "Average points: \(averagePointsString)"
                }
                if let dict = resultWinning?.first {
                    let averageWinningPointsString = String.init(format: "%.2f", dict["averagePoint"] ?? 0)
                    gameStatisticsView.averageWinningPointsLabel.text = "Average winning points: \(averageWinningPointsString)"
                }
            } catch {
                print("Error fetching result")
            }
        }
        headerViews.append(gameStatisticsView)

        let players = game.players?.allObjects as! [Player]
        var playersMatchesCountDict = [Player: Int].init()
        for player in players {
            playersMatchesCountDict[player] = 0
        }
        
        for match in matches {
            for player in match.players?.allObjects as! [Player] {
                playersMatchesCountDict[player]! += 1
            }
        }
        
        let playersSortedByActivity = players.sorted(by: {playersMatchesCountDict[$0]! > playersMatchesCountDict[$1]!})
        print(playersSortedByActivity.map({$0.name}))
        var playersCountMapped = [Int].init(repeating: 0, count: playersSortedByActivity.count)
        for (i, player) in playersSortedByActivity.enumerated() {
            playersCountMapped[i] = playersMatchesCountDict[player]!
        }
        let playersNames = playersSortedByActivity.map({$0.name!})
        
        let playersPlayingBarChart = BarChartView(dataSet: nil, dataSetMapped: playersCountMapped, newDataSet: nil, xAxisLabels: playersNames, barGapWidth: 4, reverse: true, labelsRotated: true, truncating: nil, title: "Most active players", frame: CGRect(x: 5, y: headerViews.last!.frame.maxY + 5, width: tableView.frame.width - 5, height: 150))
        headerViews.append(playersPlayingBarChart)

        
        if !matches.isEmpty && game.type == GameType.SoloWithPoints {
            do {
                let request = NSFetchRequest<PlayerResult>(entityName: "PlayerResult")
                request.predicate = NSPredicate(format: "%K = %@", #keyPath(PlayerResult.match.game), game)
                let gamePoints: [PlayerResult] = try managedContext.fetch(request)
                let pointsArray = gamePoints.map({Int($0.point)}).sorted(by: {$0 < $1})
                print(pointsArray)
                let pointsBarChartView = BarChartView(dataSet: pointsArray, dataSetMapped: nil, newDataSet: nil, xAxisLabels: nil, barGapWidth: 4, reverse: false, labelsRotated: false, truncating: nil, title: "Points distribution", frame: CGRect(x: 5, y: headerViews.last!.frame.maxY + 5, width: tableView.frame.width - 15, height: 150))
                headerViews.append(pointsBarChartView)
            } catch {
                print("Error \(error)")
            }
        }
        
        
        if game.expansions?.anyObject() != nil {
            let gameExpansions = game.expansions?.allObjects as! [Expansion]
            var expansionsCount = [Int].init(repeating: 0, count: gameExpansions.count + 1)
            for match in matches {
                if let expansions = match.expansions?.allObjects as? [Expansion], !expansions.isEmpty {
                    for expansion in expansions {
                        let index = gameExpansions.index(of: expansion)!
                        expansionsCount[index] += 1
                    }
                } else {
                    expansionsCount[gameExpansions.count] += 1
                }
            }
            var expansionsNames = gameExpansions.map({$0.name!})
            if expansionsCount[gameExpansions.count + 1] == 0 {
                expansionsCount.removeLast()
            } else {
                expansionsNames.append("None")
            }
            
            if !matches.isEmpty {
                if game.expansionsAreMultiple {
                    var dataLabels = [String]()
                    for expansionCount in expansionsCount {
                        let winPercent = Float(expansionCount) / Float(matches.count) * 100
                        let winPercentShort = String.init(format: "%.1f%", winPercent)
                        dataLabels.append("\(expansionCount)(\(winPercentShort)%)")
                    }
                    let expansionsPieChartView = PieChartView(dataSet: expansionsCount, dataName: expansionsNames, dataLabels: dataLabels, colorsArray: nil, title: "Expansions", radius: 50, truncating: nil, x: 10, y: headerViews.last!.frame.maxY + 5, width: tableView.frame.width - 10)
                    headerViews.append(expansionsPieChartView)
                } else {
                    let expansionsPieChartView = PieChartView(dataSet: expansionsCount, dataName: expansionsNames, dataLabels: nil, colorsArray: nil, title: "Expansions", radius: 50, truncating: nil, x: 10, y: headerViews.last!.frame.maxY + 5, width: tableView.frame.width - 10)
                    headerViews.append(expansionsPieChartView)
                }
            }
        }
        
        if game.scenarios?.anyObject() != nil {
            let gameScenarios = game.scenarios?.allObjects as! [Scenario]
            var scenariosCount = [Int].init(repeating: 0, count: gameScenarios.count + 1)
            for match in matches {
                if let scenarios = match.scenarios?.allObjects as? [Scenario], !scenarios.isEmpty {
                    for scenario in scenarios {
                        let index = gameScenarios.index(of: scenario)!
                        scenariosCount[index] += 1
                    }
                } else {
                    scenariosCount[gameScenarios.count] += 1
                }
            }
            var scenariosNames = gameScenarios.map({$0.name!})
            
            if scenariosCount[gameScenarios.count] == 0 {
                scenariosCount.removeLast()
            } else {
                scenariosNames.append("None")
            }
            
            if !matches.isEmpty {
                if game.scenariosAreMultiple {
                    var dataLabels = [String]()
                    for scenarioCount in scenariosCount {
                        let winPercent = Float(scenarioCount) / Float(matches.count) * 100
                        let winPercentShort = String.init(format: "%.1f%", winPercent)
                        dataLabels.append("\(scenarioCount)(\(winPercentShort)%)")
                    }
                    let scenariosPieChartView = PieChartView(dataSet: scenariosCount, dataName: scenariosNames, dataLabels: dataLabels, colorsArray: nil, title: "Scenarios", radius: 50, truncating: nil, x: 10, y: headerViews.last!.frame.maxY + 5, width: tableView.frame.width - 10)
                    headerViews.append(scenariosPieChartView)
                } else {
                    let scenariosPieChartView = PieChartView(dataSet: scenariosCount, dataName: scenariosNames, dataLabels: nil, colorsArray: nil, title: "Scenarios", radius: 50, truncating: nil, x: 10, y: headerViews.last!.frame.maxY + 5, width: tableView.frame.width - 10)
                    headerViews.append(scenariosPieChartView)
                }
            }
        }
        
        //Creating pie charts for classes
        var classesArray = [GameClass]()
        
        //fetch classes used in game as array
        do {
            let classesRequest = NSFetchRequest<GameClass>(entityName: "GameClass")
            classesRequest.predicate = NSPredicate(format: "%K == %@", #keyPath(GameClass.game.name), game.name!)
            classesArray = try managedContext.fetch(classesRequest)
        } catch {
            print(error)
        }
        
        //If there are classes
        if !classesArray.isEmpty{
            var goodClasses = [GameClass]()
            var evilClasses = [GameClass]()
            var classesDict = [GameClass: Int]()
            var winningClassesDict = [GameClass: Int]()
            
            //Sort into good and evil classes
            for gameClass in classesArray {
                if gameClass.type == ClassType.Evil {
                    evilClasses.append(gameClass)
                } else if gameClass.type == ClassType.Good {
                    goodClasses.append(gameClass)
                }
                classesDict[gameClass] = 0
                winningClassesDict[gameClass] = 0
            }
            //Assign count of classes in each match
            for match in matches {
                for playerResult in match.results?.allObjects as! [PlayerResult] {
                    if let playerClass = playerResult.gameClass {
                        classesDict[playerClass]! += 1
                        if playerResult.place == 1 {
                            winningClassesDict[playerClass]! += 1
                        }
                    }
                }
            }
            if evilClasses.isEmpty {
                let sortedClasses = classesArray.sorted(by: {classesDict[$0]! > classesDict[$1]!})
                let sorterdClassesNames = sortedClasses.map({$0.name!})
                let classesCount = sortedClasses.map({classesDict[$0]!})
                
                var dataLabels = [String]()
                for classCount in classesCount {
                    let winPercent = Float(classCount) / Float(matches.count) * 100
                    let winPercentShort = String.init(format: "%.1f%", winPercent)
                    dataLabels.append("\(classCount)(\(winPercentShort)%)")
                }
                let classesPieChartView = PieChartView(dataSet: classesCount, dataName: sorterdClassesNames, dataLabels: dataLabels, colorsArray: nil, title: "Most used classes", radius: 50, truncating: nil, x: 10, y: headerViews.last!.frame.maxY + 5, width: tableView.frame.width - 10)
                headerViews.append(classesPieChartView)
                
                
                let sortedWinningClasses = classesArray.sorted(by: {winningClassesDict[$0]! > winningClassesDict[$1]!})
                let sorterdWinningClassesNames = sortedWinningClasses.map({$0.name!})
                let winningClassesCount = sortedWinningClasses.map({winningClassesDict[$0]!})
                
                //In Coop games, the whole team can win, therefore there are many winning classes
                //So we need to take it into account when creating a pie chart
                var coopDataLabels: [String]?
                if game.type == GameType.Cooperation {
                    print("HERE")
                    coopDataLabels = [String]()
                    for classCount in winningClassesCount {
                        let winPercent = Float(classCount) / Float(matches.count) * 100
                        let winPercentShort = String.init(format: "%.1f%", winPercent)
                        coopDataLabels?.append("\(classCount)(\(winPercentShort)%)")
                    }
                }
                if !sortedWinningClasses.isEmpty {
                    let winningClassesPieChartView = PieChartView(dataSet: winningClassesCount, dataName: sorterdWinningClassesNames, dataLabels: coopDataLabels, colorsArray: nil, title: "Winning classes", radius: 50, truncating: nil, x: 10, y: headerViews.last!.frame.maxY + 5, width: tableView.frame.width - 10)
                    headerViews.append(winningClassesPieChartView)
                } else {
                    let winningClassesPieChartView = PieChartView(dataSet: [matches.count], dataName: ["None"], dataLabels: nil, colorsArray: nil, title: "Winning classes", radius: 50, truncating: nil, x: 10, y: headerViews.last!.frame.maxY + 5, width: tableView.frame.width - 10)
                    headerViews.append(winningClassesPieChartView)
                }
            } else {
                var evilWinCount = 0
                var goodWinCount = 0
                
                for (gameClass, winCount) in winningClassesDict {
                    if gameClass.type == ClassType.Evil {
                        evilWinCount += winCount
                    } else if gameClass.type == ClassType.Good {
                        goodWinCount += winCount
                    }
                }
                let teamPieChartView = PieChartView(dataSet: [goodWinCount, evilWinCount], dataName: ["Good", "Evil"], dataLabels: nil, colorsArray: [UIColor.blue, UIColor.red], title: "Win distribution", radius: 50, truncating: nil, x: 5, y: headerViews.last!.frame.maxY + 5, width: tableView.frame.width - 5)
                headerViews.append(teamPieChartView)
            }
        }
        
        let tableHeaderHeight: CGFloat = headerViews.last!.frame.maxY + 5
//
        let tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: tableHeaderHeight))

        for headerView in headerViews {
            tableHeaderView.addSubview(headerView)
        }

        tableView.tableHeaderView = tableHeaderView




    }
}

