//
//  PlayerDetailsViewController.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 06/02/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//

import UIKit

class PlayerDetailsViewController: UITableViewController {
    
    var player: Player!
    var expandedSections = [Int]()
    
    //MARK: - Overriding functions
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(PlayerDetailsCell.self, forCellReuseIdentifier: "PlayerDetailsCell")
        tableView.backgroundColor = Constants.Global.backgroundColor
    }
    
    
    //MARK: - UITableView
    
    //Conforming to UITableViewDataSource protocol
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerDetailsCell", for: indexPath) as! PlayerDetailsCell
        
        //Correct general cell options
        cell.backgroundColor = UIColor.clear
        if isEditing{
            cell.backgroundView = CellBackgroundEditingView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: cell.frame.height))
        } else {
            cell.backgroundView = CellBackgroundView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: cell.frame.height))
        }
        cell.selectionStyle = .none
        
        let game = player.gamesPlayed[indexPath.section]
        let match = player.matchesPlayed[game]![indexPath.row]
        let players = match.players
        
        //Making correct date and players Labels
        cell.dateLabel.text = match.date.toStringWithHour()
        
        var playersString = playersToString(game: game, match: match, players: players)
        
        playersString = playersString.replacingOccurrences(of: "\(player.name)", with: "<b>\(player.name)</b>")
        
        cell.playersLabel.attributedText = playersString.styled(with: Constants.myStyle)
        
        //Correcy places label
        var placeString = ""
        let place = player.gamesPlace[game]![indexPath.row]
        if game.type == .SoloWithPoints || game.type == .SoloWithPlaces {
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
        
        if game.type == .Cooperation || game.type == .TeamWithPlaces {
            if place == 1 {
                placeString = "Win"
            } else {
                placeString = "Lose"
            }
        }
        cell.placeLabel.text = placeString
        
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
        
        //Correct classes cell
        let playerClass = getPlayerClass(game: game, match: match)
        cell.classLabel.text = playerClass

        //Change color depending on team in Avalon
        if game.name == "Avalon" {
            if let playerClass = playerClass, playerClass.contains("Arthur") || playerClass.contains("Merlin") || playerClass.contains("Percival") {
                cell.classLabel.textColor = UIColor.blue
            } else {
                cell.classLabel.textColor = UIColor.red
            }
        }
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if expandedSections.index(of: section) != nil {
            let game = player.gamesPlayed[section]
            return player.matchesPlayed[game]!.count
        }
        return 0
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return player.gamesPlayed.count
    }
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let game = player.gamesPlayed[section]
        let view = PlayerDetailsSectionView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 80))
        view.titleLabel.text = "\(player.gamesPlayed[section].name) - \(player.matchesPlayed[game]!.count) matches"
        view.expandButton.tag = section
        view.expandButton.addTarget(self, action: #selector(expandButtonTapped(_:)), for: .touchUpInside)
        if expandedSections.index(of: section) != nil {
            view.expandButton.setImage(UIImage.init(named: "collapse_arrow"), for: .normal)
        } else {
            view.expandButton.setImage(UIImage.init(named: "expand_arrow"), for: .normal)
        }
        
        if game.type == .SoloWithPoints {
            view.averagePointsLabel.isHidden = false
            view.maxPointsLabel.isHidden = false
            
            var sum = 0
            for point in player.gamesPoints[game]! {
                sum += point
            }
            
            view.averagePointsLabel.text = "Average points: \(sum / (player.gamesPoints[game]?.count)!)"
            view.maxPointsLabel.text = "Max points: \(player.gamesPoints[game]!.max()!)"
        }
        
        var winCount = 0
        var loseCount = 0
        for place in player.gamesPlace[game]! {
            if place == 1 {
                winCount += 1
            } else {
                loseCount += 1
            }
        }
        
        view.winRatioLabel.text = "Win ratio: \(winCount * 100 / (winCount + loseCount))%"
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let game = player.gamesPlayed[indexPath.section]
        let match = player.matchesPlayed[game]![indexPath.row]
        let players = match.players
        var height: CGFloat = 0
        height += playersToString(game: game, match: match, players: players).height(withConstrainedWidth: tableView.frame.width - 60, font: UIFont.systemFont(ofSize: 17))
        if let classString = getPlayerClass(game: game, match: match) {
            height += classString.height(withConstrainedWidth: tableView.frame.width - 60, font: UIFont.systemFont(ofSize: 17))
        }
        return height + 30
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
    
    func playersToString(game: Game, match: Match, players: [Player]) -> String {
        var stringArray = [String]()
        for (i, player) in players.enumerated() {
            if game.type == .SoloWithPoints {
                stringArray.append("\(player.name): \(match.playersPoints![i])")
            } else if game.type == .SoloWithPlaces {
                stringArray.append("\(match.playersPlaces![i]). \(player.name)")
            } else if game.type == .TeamWithPlaces {
                if i > 0 {
                    if match.playersPlaces![i-1] == 1 && match.playersPlaces![i] == 2 {
                        stringArray.append("\nLosers: \(player.name)")
                    } else {
                        stringArray.append("\(player.name)")
                    }
                } else {
                    stringArray.append("Winners: \(player)")
                }
            } else if game.type == .Cooperation {
                stringArray.append("\(player.name)")
            }
        }
        var string = stringArray.joined(separator: ", ")
        
        //Deleting the comma at the end of Loosers line
        string = string.replacingOccurrences(of: ", \n", with: "\n")
        return string
    }
    
    func getPlayerClass(game: Game, match: Match) -> String? {
        if let customMatch = match as? CustomMatch {
            return customMatch.playersClasses?[player.playerID]
        }
        return nil
    }
}
