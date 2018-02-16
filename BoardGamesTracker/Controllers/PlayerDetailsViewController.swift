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
        let playersInMatch = player.matchesPlayed[game]![indexPath.row].players
        print(playersInMatch.map{$0.name}.joined(separator: ", "))
        cell.playersLabel.text = playersInMatch.map{$0.name}.joined(separator: ", ")
        cell.dateLabel.text = player.matchesPlayed[game]?[indexPath.row].date.toStringWithHour()
        cell.placeLabel.text = String(player.gamesPlace[game]![indexPath.row])
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
