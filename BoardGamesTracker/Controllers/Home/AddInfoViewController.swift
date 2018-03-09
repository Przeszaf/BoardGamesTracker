//
//  AddInfoViewController.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 22/02/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//

import UIKit

class AdditionalInfoViewController: UITableViewController, UINavigationControllerDelegate, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource{
    
    var picker: UIPickerView!
    
    //Available classes for Avalon game
    let myPickerDataAvalon = [AvalonClasses.goodServant, AvalonClasses.goodMerlin, AvalonClasses.goodPercival, AvalonClasses.badMinion, AvalonClasses.badAssassin, AvalonClasses.badMorgana, AvalonClasses.badMordred, AvalonClasses.badOberon]
    
    let myPickerDataPandemic = [PandemicClasses.contigencyPlanner, PandemicClasses.dispatcher, PandemicClasses.medic, PandemicClasses.quarantineSpecialist, PandemicClasses.researcher, PandemicClasses.scientist]
    let pandemicDiseasesCureStatus = ["Not cured", "Cured", "Elliminated"]
    let pandemicDiseasesName = ["Red", "Green", "Blue", "Yellow"]
    
    let myPickerData7Wonders = [SevenWondersClasses.alexandria, SevenWondersClasses.olympia, SevenWondersClasses.rome, SevenWondersClasses.another]
    
    var myPickerData: [String]!
    
    var game: Game!
    var availablePlayers: [Player]?
    var playersClasses = [Player: String]()
    var winners: [Player]?
    var loosers: [Player]?
    var toolbar: UIToolbar!
    var currentRow: Int?
    var segueKey: String?
    var dictionary = [String: Any]()
    
    //MARK: - UITableViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.delegate = self
        tableView.allowsSelection = false
        tableView.register(AddInfoCell.self, forCellReuseIdentifier: "AddInfoCell")
        
        picker = UIPickerView()
        picker.delegate = self
        
        let leftButton = UIBarButtonItem(title: "Hide", style: .plain, target: self, action: #selector(toolbarHideButton))
        let rightButton = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(toolbarNextButton))
        toolbar = Constants.Functions.createToolbarWith(leftButton: leftButton, rightButton: rightButton)
        
        if winners != nil, loosers != nil, game.name == "Avalon" {
            availablePlayers = winners! + loosers!
        }
        tableView.backgroundColor = Constants.Global.backgroundColor
        
        if game.name == "Avalon" {
            myPickerData = myPickerDataAvalon
        } else if game.name == "Pandemic" {
            myPickerData = myPickerDataPandemic
        } else if game.name == "7 Wonders" {
            myPickerData = myPickerData7Wonders
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    //MARK: - UITableView
    
    //MARK
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddInfoCell", for: indexPath) as! AddInfoCell
        cell.rightTextView.delegate = self
        cell.rightTextView.tag = indexPath.row
        cell.rightTextView.inputAccessoryView = toolbar
        cell.rightTextView.inputView = picker
        
        if segueKey == "Classes", let player = availablePlayers?[indexPath.row] {
            cell.leftLabel.text = player.name
            cell.rightTextView.text = playersClasses[player]
        } else if game.name == "Pandemic" && segueKey == "Diseases" {
            let diseasesName = pandemicDiseasesName[indexPath.row]
            cell.leftLabel.text = diseasesName
            cell.rightTextView.text = dictionary[diseasesName] as? String
        }
        
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segueKey == "Classes" {
            return availablePlayers!.count
        } else if segueKey == "Diseases" {
            return pandemicDiseasesName.count
        }
        return 0
    }
    
    
    //MARK: - UINavigationControllerDelegate
    
    //Passing selected players to previous View Controller
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if let controller = viewController as? AddMatchViewController {
            if segueKey == "Classes" {
                controller.playersClasses = playersClasses
            } else if game.name == "Pandemic" && segueKey == "Diseases" {
                controller.dictionary["Diseases"] = dictionary
            }
            controller.viewWillAppear(true)
        }
    }
    
    //MARK: - UITextViewDelegate
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return false
    }
    
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        currentRow = textView.tag
        guard let customGame = game as? CustomGame else { return false }
        
        //Different options are available for players depending on size of winners and loosers teams.
        //In Avalon, there are always more good guys than bad guys, so I use it to have team-specific classes available only.
        if let winners = winners, let loosers = loosers, customGame.name == "Avalon", let player = availablePlayers?[currentRow!]{
            if winners.contains(player) {
                if winners.count > loosers.count {
                    picker.tag = 0
                } else {
                    picker.tag = 1
                }
            } else {
                if loosers.count > winners.count {
                    picker.tag = 0
                } else {
                    picker.tag = 1
                }
            }
            if winners.count == loosers.count {
                picker.tag = 2
            }
        }
        picker.reloadAllComponents()
        
        //If the textView is clicked first time, then assign first position from pickerData to textView and dictionary
        if textView.text == "" {
            picker.selectRow(0, inComponent: 0, animated: false)
            if game.name == "Avalon" && segueKey == "Classes" {
                let player = availablePlayers![currentRow!]
                if picker.tag == 0 {
                    textView.text = myPickerDataAvalon[0]
                    playersClasses[player] = myPickerDataAvalon[0]
                } else if picker.tag == 1 {
                    textView.text = myPickerDataAvalon[3]
                    playersClasses[player] = myPickerDataAvalon[3]
                }
            } else if (game.name == "Pandemic" || game.name == "7 Wonders") && segueKey == "Classes" {
                let player = availablePlayers![currentRow!]
                textView.text = myPickerData[0]
                playersClasses[player] = myPickerData[0]
            } else if game.name == "Pandemic" && segueKey == "Diseases" {
                textView.text = pandemicDiseasesCureStatus[0]
                let cureStatus = pandemicDiseasesCureStatus[0]
                let diseaseName = pandemicDiseasesName[currentRow!]
                dictionary[diseaseName] = cureStatus
            }
            //Else go to position of picker data that is alredy chosen in dictionary
        } else if (game.name == "Pandemic" || game.name == "Avalon" || game.name == "7 Wonders") && segueKey == "Classes"{
            if let player = availablePlayers?[currentRow!], let playerClass = playersClasses[player] {
                var index = myPickerData.index(of: playerClass)
                //Make correct index for different Avalon players - there are lawful and evil professions
                //If it is evil player (tag == 1), then it shows only 5 evil profession, starting at [3] to [7]
                //But on picker, the [3] profession will be at top 0 index, therefore need to subtract
                if game.name == "Avalon" && picker.tag == 1 {
                    index = index! - 3
                }
                picker.selectRow(index!, inComponent: 0, animated: false)
            }
        } else if customGame.name == "Pandemic" && segueKey == "Diseases" {
            let cureName = pandemicDiseasesName[currentRow!]
            let cureStatus = dictionary[cureName] as! String
            let index = pandemicDiseasesCureStatus.index(of: cureStatus)
            picker.selectRow(index!, inComponent: 0, animated: false)
        }
        return true
    }
    
    //MARK: - UIPickerView
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if game.name == "Avalon" && segueKey == "Classes" {
            if picker.tag == 0 {
                return 3
            } else if picker.tag == 1 {
                return 5
            }
            return 1
        } else if (game.name == "Pandemic" || game.name == "7 Wonders") && segueKey == "Classes" {
            return myPickerData.count
        } else if game.name == "Pandemic" && segueKey == "Diseases" {
            return pandemicDiseasesCureStatus.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        guard let customGame = game as? CustomGame else { return "" }
        if customGame.name == "Avalon" {
            if picker.tag == 0 {
                return myPickerDataAvalon[row]
            } else if picker.tag == 1 {
                return myPickerDataAvalon[row+3]
            } else if picker.tag == 2 {
                return "Pick correct amount of players!"
            }
        } else if (customGame.name == "Pandemic" || customGame.name == "7 Wonders") && segueKey == "Classes" {
            return myPickerData[row]
        } else if customGame.name == "Pandemic" && segueKey == "Diseases" {
            return pandemicDiseasesCureStatus[row]
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        //When selected, then update dictionary and textView
        let cell = tableView.cellForRow(at: IndexPath(row: currentRow!, section: 0)) as! AddInfoCell
        
        if game.name == "Avalon" && segueKey == "Classes" {
            if picker.tag == 0 {
                let player = availablePlayers![currentRow!]
                playersClasses[player] = myPickerDataAvalon[row]
                cell.rightTextView.text = myPickerDataAvalon[row]
            } else if picker.tag == 1 {
                let player = availablePlayers![currentRow!]
                playersClasses[player] = myPickerDataAvalon[row + 3]
                cell.rightTextView.text = myPickerDataAvalon[row + 3]
            }
        } else if (game.name == "Pandemic" || game.name == "7 Wonders") && segueKey == "Classes" {
            let player = availablePlayers![currentRow!]
            playersClasses[player] = myPickerData[row]
            cell.rightTextView.text = myPickerData[row]
        } else if game.name == "Pandemic" && segueKey == "Diseases" {
            let cureStatus = pandemicDiseasesCureStatus[row]
            let cureName = pandemicDiseasesName[currentRow!]
            cell.rightTextView.text = pandemicDiseasesCureStatus[row]
            dictionary[cureName] = cureStatus
        }
    }
    
    //MARK: - Toolbar
    //Keyboard Toolbar button functions
    
    //When clicked on next it goes to another textField.
    @objc func toolbarNextButton() {
        if let row = currentRow, let nextCell = tableView.cellForRow(at: IndexPath(row: row + 1, section: 0)) as? AddInfoCell {
            let textView = nextCell.rightTextView
            textView.becomeFirstResponder()
            tableView.scrollToRow(at: IndexPath(row: row + 1, section: 0), at: .middle, animated: true)
        } else if let firstCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? AddInfoCell {
            let textView = firstCell.rightTextView
            textView.becomeFirstResponder()
            tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .middle, animated: true)
        }
    }
    
    @objc func toolbarHideButton() {
        if let row = currentRow, let cell = tableView.cellForRow(at: IndexPath(row: row, section: 0)) as? AddInfoCell {
            let textView = cell.rightTextView
            textView.resignFirstResponder()
        }
    }
    
}
