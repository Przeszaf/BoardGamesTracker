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
                //FIXME: Deletions
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
        let sortedPlayers = players.sorted(by: {placesDict[$0]! > placesDict[$1]!})
        
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


//        if !players.isEmpty {
//            let playersSortedByActivity = players.sorted(by: { $0.matchesPlayed[game]!.count < $1.matchesPlayed[game]!.count })
//            var playersCountMapped = [Int](repeating: 0, count: players.count)
//            var playersNames = [String]()
//            for (i, player) in playersSortedByActivity.enumerated() {
//                let matchesCount = player.matchesPlayed[game]!.count
//                playersCountMapped[i] = matchesCount
//                playersNames.append(player.name)
//            }
//            let playersPlayingBarChart = BarChartView(dataSet: nil, dataSetMapped: playersCountMapped, newDataSet: nil, xAxisLabels: playersNames, barGapWidth: 4, reverse: false, labelsRotated: true, truncating: nil, title: "Most active players", frame: CGRect(x: 5, y: headerViews.last!.frame.maxY + 5, width: tableView.frame.width - 5, height: 150))
//            headerViews.append(playersPlayingBarChart)
//        }
//
//
//        if !game.pointsArray.isEmpty {
//            let pointsArray = game.pointsArray
//            let pointsBarChartView = BarChartView(dataSet: pointsArray, dataSetMapped: nil, newDataSet: nil, xAxisLabels: nil, barGapWidth: 4, reverse: false, labelsRotated: false, truncating: nil, title: "Points distribution", frame: CGRect(x: 5, y: headerViews.last!.frame.maxY + 5, width: tableView.frame.width - 15, height: 150))
//            headerViews.append(pointsBarChartView)
//        }
//
//
//        if let expansionsArray = game.expansionsArray {
//            var expansionsCount = [Int](repeating: 0, count: expansionsArray.count + 1)
//            for match in game.matches {
//                let expansionsUsedArray = match.dictionary["Expansions"]! as! [String]
//                if expansionsUsedArray.isEmpty {
//                    expansionsCount[expansionsArray.count] += 1
//                }
//                for expansionUsed in expansionsUsedArray {
//                    let indexOfExpansion = expansionsArray.index(of: expansionUsed)!
//                    expansionsCount[indexOfExpansion] += 1
//                }
//            }
//            var expansionsNames = [String]()
//            for expansion in expansionsArray {
//                expansionsNames.append(expansion)
//            }
//            expansionsNames.append("None")
//            print(headerViews)
//            let expansionsPieChartView = PieChartView(dataSet: expansionsCount, dataName: expansionsNames, dataLabels: nil, colorsArray: nil, title: "Expansions", radius: 50, truncating: nil, x: 10, y: headerViews.last!.frame.maxY + 5, width: tableView.frame.width - 10)
//            headerViews.append(expansionsPieChartView)
//        }
//
//        if let scenariosArray = game.scenariosArray {
//            var scenariosCount = [Int](repeating: 0, count: scenariosArray.count + 1)
//            for match in game.matches {
//                let scenariosUsedArray = match.dictionary["Scenarios"]! as! [String]
//                if scenariosUsedArray.isEmpty {
//                    scenariosCount[scenariosArray.count] += 1
//                }
//                for scenarioUsed in scenariosUsedArray {
//                    let indexOfScenario = scenariosArray.index(of: scenarioUsed)!
//                    scenariosCount[indexOfScenario] += 1
//                }
//            }
//            var scenariosNames = [String]()
//            for scenario in scenariosArray {
//                scenariosNames.append(scenario)
//            }
//            scenariosNames.append("None")
//            let scenariosPieChartView = PieChartView(dataSet: scenariosCount, dataName: scenariosNames, dataLabels: nil, colorsArray: nil, title: "Scenarios", radius: 50, truncating: nil, x: 10, y: headerViews.last!.frame.maxY + 5, width: tableView.frame.width - 10)
//            headerViews.append(scenariosPieChartView)
//        }
//
//        if let classesArray = game.classesArray, game.evilClassesArray == nil {
//            var classesCount = [Int](repeating: 0, count: classesArray.count)
//            var winningClassesCount = [Int](repeating: 0, count: classesArray.count)
//            for match in game.matches {
//                var classesInMatchCount = [Int](repeating: 0, count: classesArray.count)
//                let classesUsedDict = match.dictionary["Classes"]! as! [String: String]
//                for (_, classUsed) in classesUsedDict {
//                    let indexOfClass = classesArray.index(of: classUsed)!
//                    classesInMatchCount[indexOfClass] = 1
//                }
//                //If there are 2 same classes in match, classesCount only increments its value by 1
//                for i in 0..<classesInMatchCount.count {
//                    classesCount[i] += classesInMatchCount[i]
//                }
//                if let playersPlaces = match.playersPlaces {
//                    for (i, playerPlace) in playersPlaces.enumerated() {
//                        if playerPlace == 1 {
//                            let winningPlayer = match.players[i]
//                            let winningPlayerClass = classesUsedDict[winningPlayer.playerID]!
//                            let indexOfWinningClass = classesArray.index(of: winningPlayerClass)!
//                            winningClassesCount[indexOfWinningClass] += 1
//                        }
//                    }
//                }
//            }
//
//            var classesNames = [String]()
//            for className in classesArray {
//                classesNames.append(className)
//            }
//
//            var dataLabels = [String]()
//            for classCount in classesCount {
//                let winPercent = Float(classCount) / Float(game.matches.count) * 100
//                let winPercentShort = String.init(format: "%.1f%", winPercent)
//                dataLabels.append("\(classCount)(\(winPercentShort)%)")
//            }
//
//            let classesPieChartView = PieChartView(dataSet: classesCount, dataName: classesNames, dataLabels: dataLabels, colorsArray: nil, title: "Most used classes", radius: 50, truncating: nil, x: 10, y: headerViews.last!.frame.maxY + 5, width: tableView.frame.width - 10)
//            headerViews.append(classesPieChartView)
//
//            if !winningClassesCount.isEmpty {
//                if game.type == .Cooperation {
//                    var dataLabels = [String]()
//                    for classCount in winningClassesCount {
//                        let winPercent = Float(classCount) / Float(game.matches.count) * 100
//                        let winPercentShort = String.init(format: "%.1f%", winPercent)
//                        dataLabels.append("\(classCount)(\(winPercentShort)%)")
//                    }
//                    let winningClassesPieChartView = PieChartView(dataSet: winningClassesCount, dataName: classesNames, dataLabels: dataLabels, colorsArray: nil, title: "Classes that win most time", radius: 50, truncating: nil, x: 10, y: headerViews.last!.frame.maxY + 5, width: tableView.frame.width - 10)
//                    headerViews.append(winningClassesPieChartView)
//                } else {
//                    let winningClassesPieChartView = PieChartView(dataSet: winningClassesCount, dataName: classesNames, dataLabels: nil, colorsArray: nil, title: "Classes that win most time", radius: 50, truncating: nil, x: 10, y: headerViews.last!.frame.maxY + 5, width: tableView.frame.width - 10)
//                    headerViews.append(winningClassesPieChartView)
//                }
//            }
//        }
//
//        if let evilClassesArray = game.evilClassesArray, let goodClassesArray = game.goodClassesArray {
//            var evilWinCount = 0
//            var goodWinCount = 0
//
//            var avalonKilledByAssassin = 0
//
//            for match in game.matches {
//                let winningPlayer = match.players.first!
//                let classesDict = match.dictionary["Classes"] as! [String: String]
//                let winningClass = classesDict[winningPlayer.playerID]!
//
//                if evilClassesArray.contains(winningClass) {
//                    evilWinCount += 1
//                    if game.name == "Avalon" {
//                        let wonByKillingMerlin = match.dictionary["Merlin killed"] as! Bool
//                        if wonByKillingMerlin {
//                            avalonKilledByAssassin += 1
//                        }
//                    }
//                } else if goodClassesArray.contains(winningClass) {
//                    goodWinCount += 1
//                }
//            }
//
//            if game.name == "Avalon" {
//                let teamPieChartView = PieChartView(dataSet: [goodWinCount, evilWinCount - avalonKilledByAssassin, avalonKilledByAssassin], dataName: ["Good", "Evil", "Killed Merlin"], dataLabels: nil, colorsArray: [UIColor.blue, UIColor.red, UIColor.orange], title: "Win distribution", radius: 50, truncating: nil, x: 5, y: headerViews.last!.frame.maxY + 5, width: tableView.frame.width - 5)
//                headerViews.append(teamPieChartView)
//            } else {
//                let teamPieChartView = PieChartView(dataSet: [goodWinCount, evilWinCount], dataName: ["Good", "Evil"], dataLabels: nil, colorsArray: [UIColor.blue, UIColor.red], title: "Win distribution", radius: 50, truncating: nil, x: 5, y: headerViews.last!.frame.maxY + 5, width: tableView.frame.width - 5)
//                headerViews.append(teamPieChartView)
//            }
//        }
//
//
        let tableHeaderHeight: CGFloat = headerViews.last!.frame.maxY + 5
//
        let tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: tableHeaderHeight))

        for headerView in headerViews {
            tableHeaderView.addSubview(headerView)
        }

        tableView.tableHeaderView = tableHeaderView




    }
}

