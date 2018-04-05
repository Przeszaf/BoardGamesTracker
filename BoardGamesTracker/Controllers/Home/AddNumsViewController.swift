//
//  AddPointsViewController.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 27/01/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//

import UIKit

class AddNumsViewController: UITableViewController, UINavigationControllerDelegate, UITextFieldDelegate {
    
    var game: Game!
    var availablePlayers: [Player]!
    var playersPoints: [Player: Int]!
    var playersPlaces: [Player: Int]!
    var toolbar: UIToolbar!
    var currentRow: Int?
    var currentSection: Int?
    var segueKey: String?
    var dictionary: [Player: Any]?
    var sectionNames: [ExtendedPointName]!
    
    //Key is used to determine whether this controller is used to assign places or points to players
    //MARK: - UITableViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.delegate = self
        tableView.allowsSelection = false
        tableView.register(AddNumsCell.self, forCellReuseIdentifier: "AddNumsCell")
        
        
        let leftButton = UIBarButtonItem(title: "Hide", style: .plain, target: self, action: #selector(toolbarHideButton))
        let rightButton = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(toolbarNextButton))
        toolbar = Constants.Functions.createToolbarWith(leftButton: leftButton, rightButton: rightButton)
        tableView.backgroundColor = Constants.Global.backgroundColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if availablePlayers.count != 0 {
            let cell = tableView.cellForRow(at: IndexPath(item: 0, section: 0)) as! AddNumsCell
            cell.playerNumField.becomeFirstResponder()
        }
    }
    
    
    //MARK: - UITableView
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddNumsCell", for: indexPath) as! AddNumsCell
        let player = availablePlayers[indexPath.row]
        
        cell.playerNumField.delegate = self
        cell.playerNumField.tag = indexPath.row
        cell.playerNumField.inputAccessoryView = toolbar
        cell.backgroundColor = UIColor.clear
        
        cell.playerNameLabel.text = player.name
        if segueKey == "Points" {
            if playersPoints[player] != 0 {
                cell.playerNumField.text = "\(playersPoints[player]!)"
            } else {
                cell.playerNumField.text = ""
            }
            cell.playerNumField.placeholder = "Pts"
        } else if segueKey == "Places" {
            if playersPlaces[player] != 0 {
                cell.playerNumField.text = "\(playersPlaces[player]!)"
            } else {
                cell.playerNumField.text = ""
            }
        } else if segueKey == "Extended Points" {
            cell.playerNumField.keyboardType = .numbersAndPunctuation
            if let playerDict = dictionary, let pointsDict = playerDict[player] as? [String: Int] {
                cell.playerNumField.tag = indexPath.section * 100 + indexPath.row
                if let point = pointsDict[sectionNames[indexPath.section].name!], point != -99 {
                    cell.playerNumField.text = String(point)
                } else {
                    cell.playerNumField.text = ""
                }
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return availablePlayers.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if segueKey == "Extended Points" {
            return sectionNames.count
        }
        return 1
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if segueKey == "Extended Points" {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 60))
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 30))
            label.textAlignment = .center
            view.backgroundColor = Constants.Global.backgroundColor
            view.addSubview(label)
            label.text = sectionNames[section].name!
            if game.name == "7 Wonders" {
                switch section {
                case 0:
                    view.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.6)
                case 1:
                    view.backgroundColor = UIColor(red: 0, green: 1, blue: 0, alpha: 0.6)
                default:
                    view.backgroundColor = UIColor.gray
                }
            }
            return view
        } else {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 60))
            let label = UILabel(frame: CGRect(x: 8, y: 0, width: tableView.frame.width, height: 30))
            label.textAlignment = .center
            if segueKey == "Points" {
                label.text = "Assign Points"
            } else if segueKey == "Places" {
                label.text = "Assign Places"
            }
            view.addSubview(label)
            return view
        }
    }

    //MARK: - UINavigationControllerDelegate
    
    //Passing selected players to previous View Controller
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if let controller = viewController as? AddMatchViewController {
            if segueKey == "Points" {
                controller.playersPoints = playersPoints
                _ = controller.sortPlayersPoints(players: &controller.selectedPlayers, pointsDict: playersPoints, order: "ascending")
            } else if segueKey == "Places" {
                controller.playersPlaces = playersPlaces
                controller.sortPlayersPlaces(players: &controller.selectedPlayers, placesDict: controller.playersPlaces)
            } else if segueKey == "Extended Points" {
                for player in availablePlayers {
                    var pointSum = 0
                    let playerDict = dictionary![player] as! [String: Int]
                    for (_, playerPoint) in playerDict {
                        if playerPoint != -99 {
                            pointSum += playerPoint
                        }
                    }
                    playersPoints[player] = pointSum
                }
                controller.dictionary["Points"] = dictionary
                controller.playersPoints = playersPoints
                _ = controller.sortPlayersPoints(players: &controller.selectedPlayers, pointsDict: playersPoints, order: "ascending")
            }
            controller.viewWillAppear(true)
        }
    }
    
    //MARK: - UITextFieldDelegate
    
    //Points have to be number between 1 and 999
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let tag = textField.tag
        if (Int(string) != nil && range.upperBound < 3 || string == "") {
            let numString = textField.text! + string
            var num = Int(numString) ?? 0
            if string == "" {
                num = num / 10
            }
            if num >= 0 && num <= 999 && segueKey == "Points" {
                let player = availablePlayers[tag]
                playersPoints[player] = num
                return true
            }
            //Places must be between 1 and count of players.
            if num >= 0 && num <= availablePlayers.count && segueKey == "Places" {
                let player = availablePlayers[tag]
                playersPlaces[player] = num
                return true
            }
            if num >= -98 && num <= 999 && segueKey == "Extended Points" {
                let playerIndex = currentRow!
                let sectionName = sectionNames[currentSection!].name!
                let player = availablePlayers[playerIndex]
                guard let playersDict = dictionary?[player] as? [String: Int] else { return false }
                var newPlayersDict = playersDict
                newPlayersDict[sectionName] = num
                dictionary![player] = newPlayersDict
                return true
            }
        }
        if range.upperBound == 0 && string == "-" {
            return true
        }
        return false
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        currentRow = textField.tag % 100
        currentSection = textField.tag / 100
        return true
    }
    
    //MARK: - Toolbar
    
    //Keyboard Toolbar button functions
    
    //When clicked on next it goes to another textField.
    @objc func toolbarNextButton() {
        if let row = currentRow, let nextCell = tableView.cellForRow(at: IndexPath(row: row + 1, section: currentSection ?? 0)) as? AddNumsCell {
            let textField = nextCell.playerNumField
            textField.becomeFirstResponder()
            tableView.scrollToRow(at: IndexPath(row: row + 1, section: currentSection ?? 0), at: .top, animated: true)
            print("change row")
        } else if let section = currentSection, let nextCell =  tableView.cellForRow(at: IndexPath(row: 0, section: section + 1)) as? AddNumsCell {
            let textField = nextCell.playerNumField
            textField.becomeFirstResponder()
            tableView.scrollToRow(at: IndexPath(row: 0, section: section + 1), at: .top, animated: true)
            print("change section")
        } else {
            tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            //If first cell is visible, ten make its textField first responder
            if let firstCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? AddNumsCell {
                let textField = firstCell.playerNumField
                textField.becomeFirstResponder()
            } else {
                //Else wait 0.3 seconds before making textField first responder
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3, execute: {
                    guard let firstCell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? AddNumsCell else { return }
                    let textField = firstCell.playerNumField
                    textField.becomeFirstResponder()
                })
            }
        }
    }
    
    @objc func toolbarHideButton() {
        if let row = currentRow, let cell = tableView.cellForRow(at: IndexPath(row: row, section: 0)) as? AddNumsCell {
            let textField = cell.playerNumField
            textField.resignFirstResponder()
        }
    }
    
    
}

