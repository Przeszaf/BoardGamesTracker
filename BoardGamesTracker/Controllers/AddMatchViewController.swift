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
    var winners = [Player]()
    var loosers = [Player]()
    
    var segueKey: String?
    //MARK: - Text fields outlets
    
    @IBOutlet var gameNameField: UITextField!
    @IBOutlet var playersNameView: UITextView!
    @IBOutlet var winnersNameView: UITextView!
    @IBOutlet var loosersNameView: UITextView!
    
    @IBOutlet var playersStackView: UIStackView!
    @IBOutlet var winnersStackView: UIStackView!
    @IBOutlet var loosersStackView: UIStackView!
    
    //MARK: - UIViewController functions
    override func viewDidLoad() {
        super.viewDidLoad()
        gameNameField.delegate = self
        playersNameView.delegate = self
        winnersNameView.delegate = self
        loosersNameView.delegate = self
        
        //At the beginning hide all stack views
        playersStackView.isHidden = true
        winnersStackView.isHidden = true
        loosersStackView.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        gameNameField.text = selectedGame?.name
        availablePlayers = playerStore.allPlayers
        //Every time view appears update player list
        playersNameView.text = selectedPlayers.map{$0.name}.joined(separator: ", ")
        winnersNameView.text = winners.map{$0.name}.joined(separator: ", ")
        loosersNameView.text = loosers.map{$0.name}.joined(separator: ", ")
        
        //And update visibility of stack views
        if selectedGame?.thereAreTeams == true {
            winnersStackView.isHidden = false
            loosersStackView.isHidden = false
        } else if selectedGame == nil {
            playersStackView.isHidden = true
            winnersStackView.isHidden = true
            loosersStackView.isHidden = true
        }
    }
    
    //MARK: - UITextField and UITextView delegate functions
    
    //Pressing the text field will perform a segue
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
        performSegue(withIdentifier: "choosePlayers", sender: self)
        return false
    }
    
    
    //MARK: - Managing segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "chooseGame"?:
            let chooseGameViewController = segue.destination as! ChooseGameViewController
            chooseGameViewController.gameStore = gameStore
            chooseGameViewController.selectedGame = selectedGame
        case "choosePlayers"?:
            let controller = segue.destination as! ChoosePlayersViewController
            setAvailablePlayers()
            switch segueKey {
            case "all"?:
                controller.availablePlayers = availablePlayers
                controller.selectedPlayers = selectedPlayers
                controller.key = segueKey
            case "winners"?:
                controller.availablePlayers = availablePlayers
                controller.selectedPlayers = winners
                controller.key = segueKey
                if let game = selectedGame {
                    controller.maxPlayers = game.maxNoOfPlayers - loosers.count
                }
            case "loosers"?:
                controller.availablePlayers = availablePlayers
                controller.selectedPlayers = loosers
                controller.key = segueKey
                if let game = selectedGame {
                    controller.maxPlayers = game.maxNoOfPlayers - winners.count
                }
            default:
                preconditionFailure("Wrong segue key")
            }
        default:
            preconditionFailure("Wrong segue identifier")
        }
    }
    
    //MARK: - Button
    
    @IBAction func addMatchButtonPressed(_ sender: UIBarButtonItem) {
        if let game = selectedGame {
            if game.thereAreTeams && !winners.isEmpty && !loosers.isEmpty {
                let match = Match(game: game, winners: winners, loosers: loosers)
                game.matches.append(match)
                matchStore.addMatch(match)
                
                for winner in winners {
                    winner.addMatch(game: game, match: match, place: 1)
                }
                
                for looser in loosers {
                    looser.addMatch(game: game, match: match, place: 2)
                }
            }
        }
    }
    
    //MARK: - Custom functions
    
    //Sets available players list for keys - either "loosers" or "winners"
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
}
