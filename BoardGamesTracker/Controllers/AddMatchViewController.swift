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
    
    
    //MARK: - Text fields outlets
    
    @IBOutlet var gameNameField: UITextField!
    @IBOutlet var playersNameView: UITextView!
    
    //MARK: - UIViewController functions
    override func viewDidLoad() {
        super.viewDidLoad()
        gameNameField.delegate = self
        playersNameView.delegate = self
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        gameNameField.text = selectedGame?.name
        
        if !selectedPlayers.isEmpty {
            var string = ""
            string = selectedPlayers.map{$0.name}.joined(separator: ", ")
            playersNameView.text = string
            print("I'm here")
            print(string)
        }
    }
    
    //MARK: - UITextField and UITextView delegate functions
    
    //Pressing the text field will perform a segue
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        performSegue(withIdentifier: "chooseGame", sender: self)
        
        return false
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
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
            let choosePlayersViewController = segue.destination as! ChoosePlayersViewController
            choosePlayersViewController.playerStore = playerStore
            choosePlayersViewController.selectedPlayers = selectedPlayers
        default:
            preconditionFailure("Wrong segue identifier")
        }
    }
}
