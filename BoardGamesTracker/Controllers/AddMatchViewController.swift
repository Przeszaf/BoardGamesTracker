//
//  AddMatchViewController.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 18/01/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//

import UIKit

class AddMatchViewController: UIViewController, UITextFieldDelegate {
    
    var matchStore: MatchStore!
    var gameStore: GameStore!
    var playerStore: PlayerStore!
    
    //MARK: - Variables needed to create a new match
    var chosenGame: Game?
    
    
    //MARK: - Text fields outlets
    
    @IBOutlet var gameNameField: UITextField!
    
    //MARK: - UIViewController functions
    override func viewDidLoad() {
        super.viewDidLoad()
        gameNameField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        gameNameField.text = chosenGame?.name
    }
    
    //MARK: - UITextFieldDelegate functions
    
    //Pressing the text field will perform a segue
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        performSegue(withIdentifier: "chooseGame", sender: self)
        
        return false
    }
    
    
    //MARK: - Managing segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "chooseGame"?:
            let chooseGameViewController = segue.destination as! ChooseGameViewController
            chooseGameViewController.gameStore = gameStore
            chooseGameViewController.chosenGame = chosenGame
        default:
            preconditionFailure("Wrong segue identifier")
        }
    }
}
