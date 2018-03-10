//
//  ChoosePlayersViewController.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 25/01/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//

import UIKit

class ChooserViewController: UITableViewController, UINavigationControllerDelegate {
    
    var availablePlayers: [Player]!
    var selectedPlayers: [Player]!
    var deselectedPlayers = [Player]()
    var segueKey: String!
    var maxPlayers: Int?
    var availableExpansions = [String]()
    var selectedExpansions = [String]()
    
    var availableScenarios = [String]()
    var selectedScenarios = [String]()
    
    let carcassonneExpansions = [CarcassonneExpansions.Expansion, CarcassonneExpansions.ExpansionTwo]
    let sevenWondersExpansions = [SevenWondersExpansions.cities, SevenWondersExpansions.leaders]
    let robinsonCrusoeScenarios = [RobinsonScenarios.scenario1, RobinsonScenarios.scenario2, RobinsonScenarios.scenario3]
    
    //MARK: - UITableViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.allowsMultipleSelection = true
        navigationController?.delegate = self
        
        tableView.backgroundColor = Constants.Global.backgroundColor
        tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if segueKey == "Carcassonne Expansions" {
            availableExpansions = carcassonneExpansions
        } else if segueKey == "7 Wonders Expansions" {
            availableExpansions = sevenWondersExpansions
        } else if segueKey == "Robinson Crusoe Scenarios" {
            availableScenarios = robinsonCrusoeScenarios
        }
        
        //Select players that are passed from previous view controller
        if segueKey == "all" || segueKey == "winners" || segueKey == "loosers" {
            if !selectedPlayers.isEmpty {
                for player in selectedPlayers {
                    if let playerIndex = availablePlayers.index(of: player) {
                        let indexPath = IndexPath(row: playerIndex, section: 0)
                        tableView.selectRow(at: indexPath, animated: false, scrollPosition: .bottom)
                        //set tick mark and background view
                        if let cell = tableView.cellForRow(at: indexPath) {
                            cell.accessoryType = UITableViewCellAccessoryType.checkmark
                            cell.backgroundView = CellBackgroundSelectView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: cell.frame.height))
                        }
                    }
                }
            }
        } else if !selectedExpansions.isEmpty {
            for expansion in selectedExpansions {
                let expansionIndex = availableExpansions.index(of: expansion)!
                let indexPath = IndexPath(row: expansionIndex, section: 0)
                tableView.selectRow(at: indexPath, animated: false, scrollPosition: .middle)
                //set tick mark and background view
                if let cell = tableView.cellForRow(at: indexPath) {
                    cell.accessoryType = UITableViewCellAccessoryType.checkmark
                    cell.backgroundView = CellBackgroundSelectView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: cell.frame.height))
                }
            }
        } else if !selectedScenarios.isEmpty {
            //Taking care of games where you can play only 1 scenario at time
            if segueKey == "Robinson Crusoe Scenarios" {
                selectedScenarios.removeAll()
            }
            for scenario in selectedScenarios {
                let scenarioIndex = availableScenarios.index(of: scenario)!
                let indexPath = IndexPath(row: scenarioIndex, section: 0)
                tableView.selectRow(at: indexPath, animated: false, scrollPosition: .middle)
                if let cell = tableView.cellForRow(at: indexPath) {
                    cell.accessoryType = UITableViewCellAccessoryType.checkmark
                    cell.backgroundView = CellBackgroundSelectView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: cell.frame.height))
                }
            }
        }
        if segueKey == "Robinson Crusoe Scenarios" {
            tableView.allowsMultipleSelection = false
        } else {
            tableView.allowsMultipleSelection = true
        }
    }
    
    //MARK: - UITableView
    
    //Conforming to UITableViewDataSource protocol
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "choosePlayersViewCell", for: indexPath)
        if segueKey == "all" || segueKey == "winners" || segueKey == "loosers" {
            cell.textLabel?.text = availablePlayers[indexPath.row].name
        } else if segueKey.contains("Expansion") {
            cell.textLabel?.text = availableExpansions[indexPath.row]
        } else if segueKey.contains("Scenario") {
            cell.textLabel?.text = availableScenarios[indexPath.row]
        }
        
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = .none
        if cell.isSelected {
            cell.backgroundView = CellBackgroundSelectView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: cell.frame.height))
        } else {
            cell.backgroundView = CellBackgroundView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: cell.frame.height))
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segueKey == "all" || segueKey == "winners" || segueKey == "loosers" {
            return availablePlayers.count
        } else if segueKey.contains("Expansion") {
            return availableExpansions.count
        } else if segueKey.contains("Scenario") {
            return availableScenarios.count
        }
        return 0
    }
    
    //MARK: - Using TableViewDelegate functions
    
    //Making tick marks
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        if segueKey == "all" || segueKey == "winners" || segueKey == "loosers" {
            let player = availablePlayers[indexPath.row]
            selectedPlayers.append(player)
            if let index = deselectedPlayers.index(of: player) {
                deselectedPlayers.remove(at: index)
            }
        } else if segueKey.contains("Expansion") {
            let expansion = availableExpansions[indexPath.row]
            selectedExpansions.append(expansion)
        } else if segueKey.contains("Scenario") {
            let scenario = availableScenarios[indexPath.row]
            selectedScenarios.append(scenario)
        }
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.backgroundView = CellBackgroundSelectView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: cell.frame.height))
            cell.accessoryType = .checkmark
        }
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if segueKey == "all" || segueKey == "winners" || segueKey == "loosers" {
            let player = availablePlayers[indexPath.row]
            let index = selectedPlayers.index(of: player)
            selectedPlayers.remove(at: index!)
            deselectedPlayers.append(player)
        } else if segueKey.contains("Expansion") {
            let expansion = availableExpansions[indexPath.row]
            let index = selectedExpansions.index(of: expansion)
            selectedExpansions.remove(at: index!)
        } else if segueKey.contains("Scenario") {
            let scenario = availableScenarios[indexPath.row]
            let index = selectedScenarios.index(of: scenario)
            selectedScenarios.remove(at: index!)
        }
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.backgroundView = CellBackgroundView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: cell.frame.height))
            cell.accessoryType = .none
        }
    }
    
    override func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        cell.backgroundView = CellBackgroundHighlightView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: cell.frame.height))
    }
    
    override func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        cell.backgroundView = CellBackgroundView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: cell.frame.height))
    }
    
    
    
    //MARK: - UINavigationControllerDelegate
    
    //Passing selected players to previous View Controller
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if let controller = viewController as? AddMatchViewController {
            switch segueKey {
            case "all"?:
                controller.selectedPlayers = selectedPlayers.sorted()
                controller.deselectedPlayers = deselectedPlayers.sorted()
                controller.updateDictionary()
            case "winners"?:
                controller.winners = selectedPlayers.sorted()
            case "loosers"?:
                controller.loosers = selectedPlayers.sorted()
            case _ where segueKey.contains("Expansion"):
                controller.dictionary["Expansions"] = selectedExpansions
            case _ where segueKey.contains("Scenario"):
                controller.dictionary["Scenarios"] = selectedScenarios
            default:
                preconditionFailure("Wrong segueKey!")
            }
            controller.viewWillAppear(true)
        }
    }
    
}

