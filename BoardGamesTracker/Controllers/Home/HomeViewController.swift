//
//  HomeViewController.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 06/02/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData

class HomeViewController: UIViewController {
    
    //MARK: Timer
    var timer: MyTimer!
    var games = [Game]()
    
    //MARK: Outlets
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var startButton: UIButton!
    @IBOutlet var lastMatchPlayedLabel: UILabel!
    @IBOutlet var lastGamesChart: UIView!
    
    var lastGamesBarChart: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        do {
            let request = NSFetchRequest<Game>(entityName: "Game")
            request.sortDescriptors = [NSSortDescriptor(key: "lastTimePlayed", ascending: false)]
            games = try managedContext.fetch(request)
        } catch {
            print("Error")
        }
        
        //Set timer.label to timeLabel, sot timer can update it
        timer.label = timeLabel
        timeLabel.text = timer.time.toStringWithSeconds()
        
        //Set correct button title
        if timer.isRunning {
            startButton.setTitle("Stop", for: .normal)
        }
        
        if let lastGame = games.first, let lastMatch = lastGame.matches?.anyObject() as? Match {
            let timeInterval = -(lastMatch.date?.timeIntervalSinceNow)!
            lastMatchPlayedLabel.text = "You played \(lastGame.name!) \(timeInterval.toStringWithDays()) ago."
        }
        
        
        view.backgroundColor = Constants.Global.backgroundColor
        

        lastGamesBarChart = createLastGamesBarChart()
        lastGamesChart.addSubview(lastGamesBarChart)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tabBarController?.tabBar.isHidden = false
        
        //Updates lastGamesBarChart
        lastGamesBarChart.removeFromSuperview()
        lastGamesBarChart = createLastGamesBarChart()
        lastGamesChart.addSubview(lastGamesBarChart)
    }
    
    //MARK: - Buttons
    
    @IBAction func addMatchButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "addMatch", sender: self)
    }
    
    @IBAction func showMapButtonPressed(_ sender: UIButton) {
    }
    
    //FIXME: Make Collection View Controller that shows photos.
    //First version of button
//    @IBAction func showPhotosButtonPressed(_ sender: UIButton) {
//        var matchesWithPhoto = [Match]()
//        for game in games {
//            for match in game.matches {
//                if let _ = imageStore.image(forKey: match.imageKey) {
//                    print(imageStore.imageURL(forKey: match.imageKey).path)
//                    matchesWithPhoto.append(match)
//                } else {
//                    print("No photo for match of \(game.name)")
//                }
//            }
//        }
//    }
    
    
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
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        switch segue.identifier {
//        case "addMatch"?:
//            let addMatchController = segue.destination as! AddMatchViewController
//            
//            //If timer is over 1 minute, then set the time of addMatchController to that value (in minutes)
//            if timer.time > 60 {
//                addMatchController.time = timer.time - timer.time.truncatingRemainder(dividingBy: 60)
//            }
//        case "showMap"?:
//            var locations = [CLLocation]()
//            var matches = [Match]()
//            for game in games {
//                for match in game.matches {
//                    if let location = match.location {
//                        locations.append(location)
//                        matches.append(match)
//                    }
//                }
//            }
//            let controller = segue.destination as! MapViewController
//            controller.locations = locations
//            controller.matches = matches
//        case "test"?:
//            print("Test")
//        default:
//            preconditionFailure("Wrong segue identifier")
//        }
//    }
    
    
    func createLastGamesBarChart() -> UIView {
        var mondaysArray = [String]()
        let calendar = Calendar.current

        var dateComponents = DateComponents()
        dateComponents.weekday = 2
        dateComponents.hour = 1

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.dateFormat = "MM/dd"


        let nextMonday = calendar.nextDate(after: Date(), matching: dateComponents, matchingPolicy: .nextTime, repeatedTimePolicy: .first, direction: .forward)!

        let lastMonday = calendar.nextDate(after: Date(), matching: dateComponents, matchingPolicy: .nextTime, repeatedTimePolicy: .first, direction: .backward)!

        let firstWeekVisible = calendar.date(byAdding: .day, value: -70, to: lastMonday)!

        //Create array of mondays, so it can be displayed as first day of week on graph
        for i in 0..<11 {
            let monday = calendar.date(byAdding: .day, value: -7 * i, to: lastMonday)!
            mondaysArray.append(dateFormatter.string(from: monday))
        }

        var gamesDaysAgo = [Int]()

        //Calculate how many weeks ago were all matches
        for game in games {
            if let matches = game.matches {
                for match in matches.allObjects as! [Match] {
                    if let matchDate = match.date {
                        let matchDate = matchDate as Date
                        let daysSinceMatch = calendar.dateComponents([.day], from: matchDate, to: nextMonday).day!
                        if matchDate.timeIntervalSince(firstWeekVisible) > 0 {
                            gamesDaysAgo.append(daysSinceMatch/7)
                        }
                    }
                }
            }
        }
        gamesDaysAgo.sort()

        return BarChartView(dataSet: gamesDaysAgo, dataSetMapped: nil, newDataSet: nil, xAxisLabels: mondaysArray, barGapWidth: 4, reverse: true, labelsRotated: false, truncating: nil, title: "Last matches", frame: CGRect.init(x: 0, y: 0, width: view.frame.width, height: 150))
    }
    
    
}
