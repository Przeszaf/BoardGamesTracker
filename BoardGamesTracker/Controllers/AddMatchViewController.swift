//
//  AddMatchViewController.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 18/01/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//

import UIKit

class AddMatchViewController: UIViewController, UITextViewDelegate {
    
    var gameStore: GameStore!
    var playerStore: PlayerStore!
    
    //MARK: - Variables needed to create a new match
    var selectedGame: Game?
    var selectedPlayers = [Player]()
    var availablePlayers = [Player]()
    var date: Date?
    var time: TimeInterval?
    
    //Used to pass correct values to ChoosePlayersViewController
    var segueKey: String?
    
    //Needed for team games without points
    var winners = [Player]()
    var loosers = [Player]()
    
    //Needed for solo games with points
    var playersPoints = [Player: Int]()
    var deselectedPlayers = [Player]()
    
    //Workaround of double segues
    var dateSinceSegue = Date(timeIntervalSinceNow: -1)
    
    //Pickers
    let picker = UIDatePicker()
    
    //MARK: - Outlets: text fields and stack views
    
    var gameTextView: UITextView!
    var playersTextView: UITextView!
    var winnersTextView: UITextView!
    var loosersTextView: UITextView!
    var pointsTextView: UITextView!
    var dateTextView: UITextView!
    var timeTextView: UITextView!
    
    var playersStackView: UIStackView!
    var winnersStackView: UIStackView!
    var loosersStackView: UIStackView!
    var pointsStackView: UIStackView!
    var dateStackView: UIStackView!
    var timeStackView: UIStackView!
    
    
    //MARK: - UIViewController functions
    override func viewDidLoad() {
        super.viewDidLoad()
        loadView()
        
        
        gameTextView.delegate = self
        playersTextView.delegate = self
        winnersTextView.delegate = self
        loosersTextView.delegate = self
        pointsTextView.delegate = self
        dateTextView.delegate = self
        timeTextView.delegate = self
        
        
        
        //At the beginning hide all stack views
        playersStackView.isHidden = true
        winnersStackView.isHidden = true
        loosersStackView.isHidden = true
        pointsStackView.isHidden = true
        dateStackView.isHidden = true
        timeStackView.isHidden = true
        
        dateTextView.inputView = picker
        timeTextView.inputView = picker
        picker.addTarget(self, action: #selector(pickerChanged(_:)), for: .valueChanged)
        
        date = Date()
        time = TimeInterval(exactly: 60)
        
        let toolbar = createToolbar()
        dateTextView.inputAccessoryView = toolbar
        timeTextView.inputAccessoryView = toolbar
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        gameTextView.text = selectedGame?.name
        availablePlayers = playerStore.allPlayers
        
        //Update visibility of stack views
        playersStackView.isHidden = true
        winnersStackView.isHidden = true
        loosersStackView.isHidden = true
        pointsStackView.isHidden = true
        dateStackView.isHidden = true
        timeStackView.isHidden = true
        
        updateNames()
        if let game = selectedGame {
            dateStackView.isHidden = false
            timeStackView.isHidden = false
            dateTextView.text = date?.toStringWithHour()
            timeTextView.text = time?.toString()
            if game.type == .TeamWithPlaces {
                winnersStackView.isHidden = false
                loosersStackView.isHidden = false
            } else if game.type == .SoloWithPoints {
                playersStackView.isHidden = false
                pointsStackView.isHidden = false
            }
        }
    }
    
    override func loadView() {
        super.loadView()
        let myView = AddMatchView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        view.addSubview(myView)
        myView.translatesAutoresizingMaskIntoConstraints = false
        myView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        myView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive = true
        myView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor).isActive = true
        myView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
        
        gameTextView = myView.gameTextView
        playersTextView = myView.playersTextView
        pointsTextView = myView.pointsTextView
        winnersTextView = myView.winnersTextView
        loosersTextView = myView.loosersTextView
        dateTextView = myView.dateTextView
        timeTextView = myView.timeTextView
        
        playersStackView = myView.playersStackView
        pointsStackView = myView.pointsStackView
        winnersStackView = myView.winnersStackView
        loosersStackView = myView.loosersStackView
        dateStackView = myView.dateStackView
        timeStackView = myView.timeStackView
    }
    
    //MARK: - UITextField and UITextView delegate functions
    
    //Pressing the text view will perform a segue
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView == playersTextView {
            segueKey = "all"
        } else if textView == winnersTextView {
            segueKey = "winners"
        } else if textView == loosersTextView {
            segueKey = "loosers"
        }
        //Workaround - double segues
        if Float(dateSinceSegue.timeIntervalSinceNow) < -0.1 {
            if textView == pointsTextView {
                performSegue(withIdentifier: "addPoints", sender: self)
            } else if textView == playersTextView || textView == loosersTextView || textView == winnersTextView {
                performSegue(withIdentifier: "choosePlayers", sender: self)
            } else if textView == gameTextView {
                performSegue(withIdentifier: "chooseGame", sender: self)
            }
        }
        dateSinceSegue = Date()
        
        if textView == dateTextView {
            picker.datePickerMode = .dateAndTime
            picker.maximumDate = Date()
            return true
        } else if textView == timeTextView {
            picker.datePickerMode = .countDownTimer
            return true
        }
        return false
        
    }
    
    
    //MARK: - Managing segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "chooseGame"?:
            let controller = segue.destination as! ChooseGameViewController
            controller.gameStore = gameStore
            controller.selectedGame = selectedGame
        case "choosePlayers"?:
            let controller = segue.destination as! ChoosePlayersViewController
            controller.key = segueKey
            setAvailablePlayers()
            switch segueKey {
            case "all"?:
                controller.availablePlayers = availablePlayers
                controller.selectedPlayers = selectedPlayers
                if let game = selectedGame {
                    controller.maxPlayers = game.maxNoOfPlayers
                }
            case "winners"?:
                controller.availablePlayers = availablePlayers
                controller.selectedPlayers = winners
                if let game = selectedGame {
                    controller.maxPlayers = game.maxNoOfPlayers - loosers.count
                }
            case "loosers"?:
                controller.availablePlayers = availablePlayers
                controller.selectedPlayers = loosers
                if let game = selectedGame {
                    controller.maxPlayers = game.maxNoOfPlayers - winners.count
                }
            default:
                preconditionFailure("Wrong segue key")
            }
        case "addPoints"?:
            let controller = segue.destination as! AddPointsViewController
            setPlayersPoints()
            controller.availablePlayers = selectedPlayers
            controller.playersPoints = playersPoints
        default:
            preconditionFailure("Wrong segue identifier")
        }
    }
    
    //MARK: - Button
    
    @IBAction func addMatchButtonPressed(_ sender: UIBarButtonItem) {
        if let game = selectedGame {
            if game.type == .TeamWithPlaces && !winners.isEmpty && !loosers.isEmpty {
                
                createSuccessAlert(with: "Created \(game.name)")
                clearFields()
                var places = [Int]()
                let players = winners + loosers
                for _ in winners {
                    places.append(1)
                }
                for _ in loosers {
                    places.append(2)
                }
                let match = Match(game: game, players: players, playersPoints: nil, playersPlaces: places)
                game.addMatch(match: match)
            }
            if game.type == .SoloWithPoints && !selectedPlayers.isEmpty && !playersPoints.isEmpty {
                createSuccessAlert(with: "Created \(game.name)")
                clearFields()
                var players = selectedPlayers
                let points = sortPlayersPoints(players: &players, order: "ascending")
                let places = assignPlayersPlaces(points: points)
                let match = Match(game: game, players: players, playersPoints: points, playersPlaces: places)
                game.addMatch(match: match)
            }
        }
        playerStore.allPlayers.sort()
    }
    
    //MARK: - Custom functions
    
    //Removes players that were already choosen as winners/loosers from available list of players to choose
    func setAvailablePlayers() {
        availablePlayers = playerStore.allPlayers
        if segueKey == "loosers" {
            for winner in winners {
                let index = availablePlayers.index(of: winner)
                availablePlayers.remove(at: index!)
            }
        } else if segueKey == "winners" {
            for looser in loosers {
                let index = availablePlayers.index(of: looser)
                availablePlayers.remove(at: index!)
            }
        }
        
    }
    
    //Updates playersPoints dictionary when new player is selected or deselected
    func setPlayersPoints() {
        for player in selectedPlayers {
            if playersPoints[player] == nil {
                playersPoints[player] = 0
            }
        }
        for player in deselectedPlayers {
            playersPoints[player] = nil
        }
    }
    
    //Updates names of views
    func updateNames() {
        playersTextView.text = selectedPlayers.map{$0.name}.joined(separator: ", ")
        winnersTextView.text = winners.map{$0.name}.joined(separator: ", ")
        loosersTextView.text = loosers.map{$0.name}.joined(separator: ", ")
        var string = [String]()
        for player in selectedPlayers {
            string.append("\(player.name): \(playersPoints[player]!)")
        }
        pointsTextView.text = string.joined(separator: ", ")
    }
    
    
    //Function sorts players by amount of points, either ascending or descending, returning the points array
    func sortPlayersPoints(players: inout [Player], order key: String) -> [Int] {
        var points = [Int]()
        for player in players {
            let point = playersPoints[player]
            points.append(point!)
        }
        var newPlayers = [Player]()
        var newPoints = [Int]()
        switch key {
        case "ascending":
            for _ in 0..<players.count {
                let max = points.max()!
                let index = points.index(of: max)!
                newPlayers.append(players[index])
                newPoints.append(points[index])
                points[index] = -1
            }
        case "descending":
            for _ in 0..<players.count {
                let min = points.min()!
                let index = points.index(of: min)!
                newPlayers.append(players[index])
                newPoints.append(points[index])
                points[index] = 1000
            }
        default:
            preconditionFailure("Wrong order key")
        }
        players = newPlayers
        return newPoints
    }
    
    //Function takes points array (sorted) as an argument and return places
    func assignPlayersPlaces(points: [Int]) -> [Int] {
        var places = [Int].init(repeating: 0, count: points.count)
        places[0] = 1
        for i in 1..<points.count {
            if points[i] == points[i-1] {
                places[i] = places[i-1]
            } else {
                places[i] = i+1
            }
        }
        return places
    }
    
    func createSuccessAlert(with string: String) {
        let alert = UIAlertController(title: "Success!", message: string, preferredStyle: .alert)
        alert.setValue(NSAttributedString(string: alert.title!, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.medium), NSAttributedStringKey.foregroundColor : UIColor.magenta]), forKey: "attributedTitle")
        alert.setValue(NSAttributedString(string: alert.message!, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.medium), NSAttributedStringKey.foregroundColor : UIColor.blue]), forKey: "attributedMessage")
        self.present(alert, animated: true, completion: nil)
        let time = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: time) {
            alert.dismiss(animated: true, completion: {
                self.navigationController?.popToRootViewController(animated: true)
            })
        }
    }
    
    func createFailureAlert(with string: String) {
        let alert = UIAlertController(title: "Failure!", message: string, preferredStyle: .alert)
        alert.setValue(NSAttributedString(string: alert.title!, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.medium), NSAttributedStringKey.foregroundColor : UIColor.magenta]), forKey: "attributedTitle")
        alert.setValue(NSAttributedString(string: alert.message!, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.medium), NSAttributedStringKey.foregroundColor : UIColor.blue]), forKey: "attributedMessage")
        self.present(alert, animated: true, completion: nil)
        let time = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: time) {
            alert.dismiss(animated: true, completion: nil)
        }
    }
    
    func clearFields() {
        gameTextView.text = ""
        playersTextView.text = ""
        winnersTextView.text = ""
        loosersTextView.text = ""
        pointsTextView.text = ""
    }
    
    //MARK: - Picker toolbar
    
    func createToolbar() -> UIToolbar {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(cancelPicker))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        return toolBar
    }
    
    
    
    //PickerView Toolbar button functions
    @objc func donePicker() {
        if picker.datePickerMode == .countDownTimer {
            time = picker.countDownDuration
            timeTextView.text = time?.toString()
        } else if picker.datePickerMode == .dateAndTime {
            date = picker.date
            dateTextView.text = date?.toStringWithHour()
        }
        resignFirstResponder()
    }
    
    @objc func cancelPicker() {
        if picker.datePickerMode == .countDownTimer {
            time = TimeInterval(exactly: 60)
            timeTextView.text = time?.toString()
        } else if picker.datePickerMode == .dateAndTime {
            date = Date()
            dateTextView.text = date?.toStringWithHour()
        }
        resignFirstResponder()
    }
    
    @objc func pickerChanged(_ sender: UIDatePicker) {
        if sender.datePickerMode == .countDownTimer {
            timeTextView.text = sender.countDownDuration.toString()
        } else if sender.datePickerMode == .dateAndTime {
            dateTextView.text = sender.date.toStringWithHour()
        }
    }
    
    
}
