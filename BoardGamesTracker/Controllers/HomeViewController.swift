//
//  HomeViewController.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 06/02/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    var gameStore: GameStore!
    var playerStore: PlayerStore!
    var timer: MyTimer!
    
    
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var startButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timer.label = timeLabel
        timeLabel.text = timer.time.toStringWithSeconds()
        if timer.isRunning {
            startButton.setTitle("Stop", for: .normal)
        }
    }
    
    //MARK: - Buttons
    
    @IBAction func addMatchButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "addMatch", sender: self)
    }
    
    @IBAction func startTimerButtonPressed(_ sender: UIButton) {
        if sender.currentTitle == "Start" {
            timer.runTimer()
            startButton.setTitle("Stop", for: .normal)
        } else if sender.currentTitle == "Stop" {
            timer.stopTimer()
            startButton.setTitle("Start", for: .normal)
        }
    }
    
    @IBAction func resetTimerButtonPressed(_ sender: UIButton) {
        timer.resetTimer()
        startButton.setTitle("Start", for: .normal)
    }
    
    //MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "addMatch"?:
            let addMatchController = segue.destination as! AddMatchViewController
            addMatchController.gameStore = gameStore
            addMatchController.playerStore = playerStore
            if timer.time > 60 {
                addMatchController.time = timer.time - timer.time.truncatingRemainder(dividingBy: 60)
            }
        default:
            preconditionFailure("Wrong segue identifier")
        }
    }
    
    
}
