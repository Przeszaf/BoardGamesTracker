//
//  PlayerDetailsViewController.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 06/02/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//

import UIKit
import CoreData

class PlayerDetailsViewController: UITableViewController {

    var player: Player!
    var games: [Game]!
    var expandedSections = [Int]()
    var matches = [Game: [Match]]()
    
    var managedContext: NSManagedObjectContext!

    //MARK: - Overriding functions
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(PlayerDetailsCell.self, forCellReuseIdentifier: "PlayerDetailsCell")
        tableView.backgroundColor = Constants.Global.backgroundColor
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        managedContext = appDelegate.persistentContainer.viewContext
        
        do {
            let gameRequest = NSFetchRequest<Game>(entityName: "Game")
            gameRequest.predicate = NSPredicate(format: "ANY players == %@", player)
            gameRequest.sortDescriptors = [NSSortDescriptor(key: "lastTimePlayed", ascending: false)]
            games = try managedContext.fetch(gameRequest)
        } catch {
            print("HAHAHAHA \(error)")
        }
        
        for game in games {
            do {
                let request = NSFetchRequest<Match>(entityName: "Match")
                request.predicate = NSPredicate(format: "ANY players == %@ AND game == %@", player, game)
                request.sortDescriptors = [NSSortDescriptor.init(key: "date", ascending: false)]
                matches[game] = try managedContext.fetch(request)
            } catch {
                print(error)
            }
        }
    }


    //MARK: - UITableView

    //Conforming to UITableViewDataSource protocol
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerDetailsCell", for: indexPath) as! PlayerDetailsCell

        cell.backgroundColor = UIColor.clear
        if isEditing{
            cell.backgroundView = CellBackgroundEditingView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: cell.frame.height))
        } else {
            cell.backgroundView = CellBackgroundView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: cell.frame.height))
        }
        cell.selectionStyle = .none
        
        
        
        let game = games[indexPath.section]
        let match = matches[game]![indexPath.row]
        
        //Making correct date and players Labels
        cell.dateLabel.text = match.date?.toStringWithHour()

        var playersString = playersToString(playersResults: match.results?.allObjects as! [PlayerResult])

        //Bolds player name
        playersString = playersString.replacingOccurrences(of: "\(player.name!)", with: "<b>\(player.name!)</b>")
        cell.playersLabel.attributedText = playersString.styled(with: Constants.myStyle)

        //Correct places label
        var placeString = ""
        var playerResult: PlayerResult!
        do {
            let request = NSFetchRequest<PlayerResult>(entityName: "PlayerResult")
            request.predicate = NSPredicate(format: "%K == %@ AND %K == %@", #keyPath(PlayerResult.player), player, #keyPath(PlayerResult.match), match)
            request.fetchLimit = 1
            playerResult = try managedContext.fetch(request).first!
        } catch {
            print(error)
        }
        let place = Int(playerResult.place)
        if game.type == GameType.SoloWithPoints || game.type == GameType.SoloWithPlaces {
            placeString.append(String(place))
            switch place {
            case 1:
                placeString.append("st")
            case 2:
                placeString.append("nd")
            case 3:
                placeString.append("rd")
            default:
                placeString.append("th")
            }
        }

        if game.type == GameType.Cooperation || game.type == GameType.TeamWithPlaces {
            if place == 1 {
                placeString = "Win"
            } else {
                placeString = "Lose"
            }
        }
        cell.placeLabel.text = placeString

        //Different colors for different places
        //FIXME: Better colors
        switch placeString {
        case "1st":
            cell.placeLabel.textColor = UIColor.yellow
        case "2nd":
            cell.placeLabel.textColor = UIColor(red: 214/255, green: 214/255, blue: 214/255, alpha: 1)
        case "3rd":
            cell.placeLabel.textColor = UIColor.brown
        case "Win":
            cell.placeLabel.textColor = UIColor.green
        case "Lose":
            cell.placeLabel.textColor = UIColor.red
        default:
            cell.placeLabel.textColor = UIColor.black
        }

        //Correct classes string
        let playerClassString = playerResult.gameClass?.name
        cell.classLabel.text = playerClassString

        //FIXME: Can be done better now
        //Change color depending on team in Avalon
        if game.name == "Avalon" {
            if let playerClass = playerClassString, playerClass.contains("Arthur") || playerClass.contains("Merlin") || playerClass.contains("Percival") {
                cell.classLabel.textColor = UIColor.blue
            } else {
                cell.classLabel.textColor = UIColor.red
            }
        }
        return cell
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //If there are no expanded sections, then no rows, else show matches.
        if expandedSections.index(of: section) != nil {
            let game = games[section]
            return matches[game]?.count ?? 0
        }
        return 0
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return games.count
    }


    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let game = games[section]
        let view = PlayerDetailsSectionView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 80))
        view.titleLabel.text = "\(games[section].name!) - \(matches[game]?.count ?? 0) matches"
        view.expandButton.tag = section
        view.expandButton.addTarget(self, action: #selector(expandButtonTapped(_:)), for: .touchUpInside)
        if expandedSections.index(of: section) != nil {
            view.expandButton.setImage(UIImage.init(named: "collapse_arrow"), for: .normal)
        } else {
            view.expandButton.setImage(UIImage.init(named: "expand_arrow"), for: .normal)
        }
        

        //If it is game with points, then show average and maximum points that player got
        if game.type == GameType.SoloWithPoints {
            view.averagePointsLabel.isHidden = false
            view.maxPointsLabel.isHidden = false

            
            let keypathExpression = NSExpression(forKeyPath: "point")
            let maxExpression = NSExpression(forFunction: "max:", arguments: [keypathExpression])
            let averageExpression = NSExpression(forFunction: "average:", arguments: [keypathExpression])
            
            let maxExpressionDescription = NSExpressionDescription()
            maxExpressionDescription.expression = maxExpression
            maxExpressionDescription.name = "maxPoint"
            maxExpressionDescription.expressionResultType = .integer32AttributeType
            
            let averageExpressionDescription = NSExpressionDescription()
            averageExpressionDescription.expression = averageExpression
            averageExpressionDescription.name = "averagePoint"
            averageExpressionDescription.expressionResultType = .doubleAttributeType
            
            let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest()
            request.entity = NSEntityDescription.entity(forEntityName: "PlayerResult", in: managedContext)
            request.resultType = NSFetchRequestResultType.dictionaryResultType
            request.predicate = NSPredicate(format: "%K == %@ AND player == %@", #keyPath(PlayerResult.match.game), game, player)
            
            request.propertiesToFetch = [maxExpressionDescription, averageExpressionDescription]
            
            do {
                let result = try managedContext.fetch(request) as? [[String: Double]]
                if let dict = result?.first {
                    let maxPoints = Int(dict["maxPoint"] ?? 0)
                    view.maxPointsLabel.text = "Max points: \(maxPoints)"
                    let averagePointsString = String.init(format: "%.2f", dict["averagePoint"] ?? 0)
                    view.averagePointsLabel.text = "Average points: \(averagePointsString)"
                }
            } catch {
                print(error)
            }
        }

        var playerResults = [PlayerResult]()
        do {
            let request = NSFetchRequest<PlayerResult>(entityName: "PlayerResult")
            request.predicate = NSPredicate(format: "%K == %@ AND player == %@", #keyPath(PlayerResult.match.game), game, player)
            playerResults = try managedContext.fetch(request)
        } catch {
            print(error)
        }
        var winCount = 0
        var loseCount = 0
        for playerResult in playerResults {
            if playerResult.place == 1 {
                winCount += 1
            } else {
                loseCount += 1
            }
        }
        //Show win ratio for game
        view.winRatioLabel.text = "Win ratio: \(winCount * 100 / (winCount + loseCount))%"
        return view
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let game = games[indexPath.section]
        let match = matches[game]![indexPath.row]
        
        var playerResult: PlayerResult!
        do {
            let request = NSFetchRequest<PlayerResult>(entityName: "PlayerResult")
            request.predicate = NSPredicate(format: "player == %@ AND match == %@", player, match)
            request.fetchLimit = 1
            playerResult = try managedContext.fetch(request).first!
        } catch {
            print(error)
        }
        
        let playersResults = match.results?.allObjects as! [PlayerResult]
        
        var height: CGFloat = 0
        height += playersToString(playersResults: playersResults).height(withConstrainedWidth: tableView.frame.width - 70, font: UIFont.systemFont(ofSize: 17))
        if let classString = getPlayerClass(playerResult: playerResult) {
            height += classString.height(withConstrainedWidth: tableView.frame.width - 70, font: UIFont.systemFont(ofSize: 17))
        }
        return height + 40
    }

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

    @objc func expandButtonTapped(_ button: UIButton) {
        if let index = expandedSections.index(of: button.tag){
            expandedSections.remove(at: index)
            tableView.reloadSections(IndexSet([button.tag]), with: .automatic)
        } else {
            expandedSections.append(button.tag)
            tableView.reloadSections(IndexSet([button.tag]), with: .automatic)
            tableView.updateConstraints()
        }
    }

    func playersToString(playersResults: [PlayerResult]) -> String {
        let game = playersResults.first!.match!.game!
        var stringArray = [String]()
        var playersPoints = [Player: Int]()
        var playersPlaces = [Player: Int]()
        for playerResult in playersResults {
            playersPlaces[playerResult.player!] = Int(playerResult.place)
            playersPoints[playerResult.player!] = Int(playerResult.point)
        }
        let players = playersResults.map({$0.player!})
        let sortedPlayers = players.sorted(by: {playersPlaces[$0]! < playersPlaces[$1]!})
        
        if game.type == GameType.TeamWithPlaces {
            stringArray.append("Winners: ")
        }
        for (i, player) in sortedPlayers.enumerated() {
            if game.type == GameType.SoloWithPoints {
                stringArray.append("\(player.name!): \(playersPoints[player] ?? 0)")
            } else if game.type == GameType.SoloWithPlaces {
                stringArray.append("\(playersPlaces[player]!). \(player.name!)")
            } else if game.type == GameType.TeamWithPlaces {
                if i > 0 {
                    //Detects when players change from winning to losing
                    if playersPlaces[sortedPlayers[i-1]]! == 1 && playersPlaces[player]! == 2 {
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

        //Deleting the comma at the end of Loosers line
        string = string.replacingOccurrences(of: ", \n", with: "\n")
        return string
    }

    func getPlayerClass(playerResult: PlayerResult) -> String? {
        return playerResult.gameClass?.name!
    }
}

