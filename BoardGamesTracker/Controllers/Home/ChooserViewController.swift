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
    var availableExpansions: [Expansion]!
    var selectedExpansions = [Expansion]()
    var availableScenarios: [Scenario]!
    var selectedScenarios = [Scenario]()
    var multipleAllowed: Bool?
    
    //MARK: - Lifecycle of VC
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.allowsMultipleSelection = true
        navigationController?.delegate = self
        
        tableView.backgroundColor = Constants.Global.backgroundColor
        tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        //Select players that are passed from previous view controller
        if segueKey == "all" || segueKey == "winners" || segueKey == "loosers" || segueKey == "PVP" {
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
            //Select scenarios and expansions passed from previous VC
        } else if (!selectedScenarios.isEmpty || !selectedExpansions.isEmpty) && multipleAllowed == true {
            for selection in selectedScenarios {
                let selectionIndex = availableScenarios.index(of: selection)!
                let indexPath = IndexPath(row: selectionIndex, section: 0)
                tableView.selectRow(at: indexPath, animated: false, scrollPosition: .middle)
                //set tick mark and background view
                if let cell = tableView.cellForRow(at: indexPath) {
                    cell.accessoryType = UITableViewCellAccessoryType.checkmark
                    cell.backgroundView = CellBackgroundSelectView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: cell.frame.height))
                }
            }
            for selection in selectedExpansions {
                let selectionIndex = availableExpansions.index(of: selection)!
                let indexPath = IndexPath(row: selectionIndex, section: 0)
                tableView.selectRow(at: indexPath, animated: false, scrollPosition: .middle)
                //set tick mark and background view
                if let cell = tableView.cellForRow(at: indexPath) {
                    cell.accessoryType = UITableViewCellAccessoryType.checkmark
                    cell.backgroundView = CellBackgroundSelectView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: cell.frame.height))
                }
            }
        }

        if multipleAllowed == false {
            tableView.allowsMultipleSelection = false
            selectedExpansions.removeAll()
            selectedScenarios.removeAll()
        } else {
            tableView.allowsMultipleSelection = true
        }
        
        //Add new button if chooser if for PVP
        if segueKey == "PVP" {
            let button = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(nextButtonPressed(_:)))
            navigationItem.rightBarButtonItem = button
        }
    }
    
    //MARK: - UITableView
    
    //Conforming to UITableViewDataSource protocol
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "choosePlayersViewCell", for: indexPath)
        //Set correct textLabel
        if segueKey == "all" || segueKey == "winners" || segueKey == "loosers" || segueKey == "PVP" {
            cell.textLabel?.text = availablePlayers[indexPath.row].name
        } else if segueKey == "Expansions" {
            cell.textLabel?.text = availableExpansions[indexPath.row].name!
        } else if segueKey == "Scenarios" {
            cell.textLabel?.text = availableScenarios[indexPath.row].name!
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
        if segueKey == "all" || segueKey == "winners" || segueKey == "loosers" || segueKey == "PVP" {
            return availablePlayers.count
        } else if segueKey == "Scenarios" {
            return availableScenarios.count
        } else if segueKey == "Expansions" {
            return availableExpansions.count
        }
        return 0
    }
    
    //Making tick marks
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        if segueKey == "all" || segueKey == "winners" || segueKey == "loosers" || segueKey == "PVP" {
            let player = availablePlayers[indexPath.row]
            selectedPlayers.append(player)
            if let index = deselectedPlayers.index(of: player) {
                deselectedPlayers.remove(at: index)
            }
        } else if segueKey == "Expansions" {
            let selection = availableExpansions[indexPath.row]
            selectedExpansions.append(selection)
        } else if segueKey == "Scenarios" {
            let selection = availableScenarios[indexPath.row]
            selectedScenarios.append(selection)
        }
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.backgroundView = CellBackgroundSelectView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: cell.frame.height))
            cell.accessoryType = .checkmark
        }
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if segueKey == "all" || segueKey == "winners" || segueKey == "loosers" || segueKey == "PVP" {
            let player = availablePlayers[indexPath.row]
            let index = selectedPlayers.index(of: player)
            selectedPlayers.remove(at: index!)
            deselectedPlayers.append(player)
        } else if segueKey == "Expansions" {
            let deselection = availableExpansions[indexPath.row]
            let index = selectedExpansions.index(of: deselection)
            selectedExpansions.remove(at: index!)
        } else if segueKey == "Scenarios" {
            let deselection = availableScenarios[indexPath.row]
            let index = selectedScenarios.index(of: deselection)
            selectedScenarios.remove(at: index!)
        }
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.backgroundView = CellBackgroundView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: cell.frame.height))
            cell.accessoryType = .none
        }
    }
    
    //Setting correct background views for cells
    override func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        cell.backgroundView = CellBackgroundHighlightView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: cell.frame.height))
    }
    
    override func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        cell.backgroundView = CellBackgroundView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: cell.frame.height))
    }
    
    
    
    //MARK: - UINavigationControllerDelegate
    
    //Passing data to previous View Controller
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if let controller = viewController as? AddMatchViewController {
            switch segueKey {
            case "all"?:
                controller.selectedPlayers = selectedPlayers
                controller.deselectedPlayers = deselectedPlayers
                controller.updateDictionary()
            case "winners"?:
                controller.winners = selectedPlayers
            case "loosers"?:
                controller.loosers = selectedPlayers
            case _ where segueKey == "Expansions":
                controller.dictionary["Expansions"] = selectedExpansions
            case _ where segueKey == "Scenarios" :
                controller.dictionary["Scenarios"] = selectedScenarios
            default:
                preconditionFailure("Wrong segueKey!")
            }
            controller.viewWillAppear(true)
        }
    }
    
    //MARK: - PVP handling
    
    @objc func nextButtonPressed(_ sender: UIBarButtonItem) {
        if selectedPlayers.count == 2 {
            performSegue(withIdentifier: "PVP", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PVP" {
            let controller = segue.destination as! PVPViewController
            controller.firstPlayer = selectedPlayers.first
            controller.secondPlayer = selectedPlayers.last
        }
    }
    
    
}


