//
//  AddMatchViewController.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 18/01/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//

import UIKit

class AddMatchViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    var matchStore: MatchStore!
    var gameStore: GameStore!
    var playerStore: PlayerStore!
    
    //MARK: - Variables needed to create a new match
    var selectedGame: Game?
    var selectedPlayers = [Player]()
    var availablePlayers = [Player]()
    
    //Used to pass correct values to ChoosePlayersViewController
    var segueKey: String?
    
    //Needed for team games without points
    var winners = [Player]()
    var loosers = [Player]()
    
    //Needed for solo games with points
    var playersPoints = [Player: Int]()
    var deselectedPlayers = [Player]()
    
    //Workaround of double segues
    var date = Date()
    
    //MARK: - Outlets: text fields and stack views
    
    @IBOutlet var gameNameField: UITextField!
    @IBOutlet var playersNameView: UITextView!
    @IBOutlet var winnersNameView: UITextView!
    @IBOutlet var loosersNameView: UITextView!
    @IBOutlet var pointsView: UITextView!
    
    @IBOutlet var playersStackView: UIStackView!
    @IBOutlet var winnersStackView: UIStackView!
    @IBOutlet var loosersStackView: UIStackView!
    @IBOutlet var pointsStackView: UIStackView!
    
    //MARK: - UIViewController functions
    override func viewDidLoad() {
        super.viewDidLoad()
        gameNameField.delegate = self
        playersNameView.delegate = self
        winnersNameView.delegate = self
        loosersNameView.delegate = self
        pointsView.delegate = self
        
        //At the beginning hide all stack views
        playersStackView.isHidden = true
        winnersStackView.isHidden = true
        loosersStackView.isHidden = true
        pointsStackView.isHidden = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        gameNameField.text = selectedGame?.name
        availablePlayers = playerStore.allPlayers
        
        //Update visibility of stack views
        playersStackView.isHidden = true
        winnersStackView.isHidden = true
        loosersStackView.isHidden = true
        pointsStackView.isHidden = true
        
        updateNames()
        
        if selectedGame?.thereAreTeams == true {
            winnersStackView.isHidden = false
            loosersStackView.isHidden = false
        } else if selectedGame?.maxNoOfPoints != nil {
            playersStackView.isHidden = false
            pointsStackView.isHidden = false
        }
    }
    
    //MARK: - UITextField and UITextView delegate functions
    
    //Pressing the text field or text view will perform a segue
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        performSegue(withIdentifier: "chooseGame", sender: self)
        return false
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView == playersNameView {
            segueKey = "all"
        } else if textView == winnersNameView {
            segueKey = "winners"
        } else if textView == loosersNameView {
            segueKey = "loosers"
        }
        //Workaround - double segues
        if Float(date.timeIntervalSinceNow) < -1.0 {
            if textView == pointsView {
                performSegue(withIdentifier: "addPoints", sender: self)
            } else if textView == playersNameView || textView == loosersNameView || textView == winnersNameView {
                performSegue(withIdentifier: "choosePlayers", sender: self)
            }
        }
        date = Date()
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
                matchStore.addMatch(match)
                
            }
            if game.type == .SoloWithPoints && !selectedPlayers.isEmpty && !playersPoints.isEmpty {
                createSuccessAlert(with: "Created \(game.name)")
                clearFields()
                var players = selectedPlayers
                let points = sortPlayersPoints(players: &players, order: "ascending")
                let places = assignPlayersPlaces(points: points)
                let match = Match(game: game, players: players, playersPoints: points, playersPlaces: places)
                matchStore.addMatch(match)
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
        playersNameView.text = selectedPlayers.map{$0.name}.joined(separator: ", ")
        winnersNameView.text = winners.map{$0.name}.joined(separator: ", ")
        loosersNameView.text = loosers.map{$0.name}.joined(separator: ", ")
        var string = [String]()
        for player in selectedPlayers {
            string.append("\(player.name): \(playersPoints[player]!)")
        }
        pointsView.text = string.joined(separator: ", ")
    }
    
    
    //Function sorts players by amount of points, either ascending or descending
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
    
    //Function takes points (sorted) as an argument and return places
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
    
    func clearFields() {
        gameNameField.text = ""
        playersNameView.text = ""
        winnersNameView.text = ""
        loosersNameView.text = ""
        pointsView.text = ""
    }
    
}
