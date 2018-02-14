//
//  HomeViewController.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 06/02/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//

import UIKit
import CoreLocation

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
    
    @IBAction func showMapButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "showMap", sender: self)
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
        case "showMap"?:
            var locations = [CLLocation]()
            var matches = [Match]()
            for game in gameStore.allGames {
                for match in game.matches {
                    if let location = match.location {
                        locations.append(location)
                        matches.append(match)
                    }
                }
            }
            let controller = segue.destination as! MapViewController
            controller.locations = locations
            controller.matches = matches
        default:
            preconditionFailure("Wrong segue identifier")
        }
    }
    
    
}
