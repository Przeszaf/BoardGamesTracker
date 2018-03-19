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
    var availableArray = [String]()
    var selectedArray = [String]()
    var multipleAllowed: Bool?
    
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
        } else if !selectedArray.isEmpty && multipleAllowed == true {
            for selection in selectedArray {
                let selectionIndex = availableArray.index(of: selection)!
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
            selectedArray.removeAll()
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
        } else if segueKey == "Expansions" || segueKey == "Scenarios" {
            cell.textLabel?.text = availableArray[indexPath.row]
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
        } else if segueKey == "Expansions" || segueKey == "Scenarios" {
            return availableArray.count
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
        } else if segueKey == "Expansions" || segueKey == "Scenarios" {
            let selection = availableArray[indexPath.row]
            selectedArray.append(selection)
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
        } else if segueKey == "Expansions" || segueKey == "Scenarios" {
            let deselection = availableArray[indexPath.row]
            let index = selectedArray.index(of: deselection)
            selectedArray.remove(at: index!)
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
            case _ where segueKey == "Expansions":
                controller.dictionary["Expansions"] = selectedArray
            case _ where segueKey == "Scenarios" :
                controller.dictionary["Scenarios"] = selectedArray
            default:
                preconditionFailure("Wrong segueKey!")
            }
            controller.viewWillAppear(true)
        }
    }
    
}

