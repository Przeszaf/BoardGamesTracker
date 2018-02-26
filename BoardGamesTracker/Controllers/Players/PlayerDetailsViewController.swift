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
        
        tableView.rowHeight = 70
        tableView.register(PlayerDetailsCell.self, forCellReuseIdentifier: "PlayerDetailsCell")
    }
    
    
    //MARK: - UITableView
    
    //Conforming to UITableViewDataSource protocol
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerDetailsCell", for: indexPath) as! PlayerDetailsCell
        let game = player.gamesPlayed[indexPath.section]
        let match = player.matchesPlayed[game]![indexPath.row]
        let players = match.players
        cell.dateLabel.text = match.date.toStringWithHour()
        
        var string = [String]()
        for (i, player) in players.enumerated() {
            if game.type == .SoloWithPoints {
                string.append("\(player.name): \(match.playersPoints![i])")
            } else if game.type == .SoloWithPlaces {
                string.append("\(match.playersPlaces![i]). \(player.name)")
            } else if game.type == .TeamWithPlaces {
                if i > 0 {
                    if match.playersPlaces![i-1] == 1 && match.playersPlaces![i] == 2 {
                        string.append("Losers: \(player.name)")
                    } else {
                        string.append("\(player.name)")
                    }
                } else {
                    string.append("Winners: \(player)")
                }
            } else if game.type == .Cooperation {
                string.append("\(player.name)")
            }
        }
        cell.playersLabel.text = string.joined(separator: ", ")
        
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
    
    @objc func expandButtonTapped(_ button: UIButton) {
        if let index = expandedSections.index(of: button.tag){
            expandedSections.remove(at: index)
            tableView.reloadSections(IndexSet([button.tag]), with: .automatic)
        } else {
            expandedSections.append(button.tag)
            tableView.reloadSections(IndexSet([button.tag]), with: .automatic)
        }
    }
    
}
