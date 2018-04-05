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
    
    var managedContext: NSManagedObjectContext!
    
    var lastGamesBarChart: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        managedContext = appDelegate.persistentContainer.viewContext
        
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
        var matches = [Match]()
        do {
            let request = NSFetchRequest<Match>(entityName: "Match")
            request.predicate = NSPredicate(format: "longitude != nil AND latitude != nil", argumentArray: nil)
            matches = try managedContext.fetch(request)
        } catch {
            print("Error fetching locations")
        }
        performSegue(withIdentifier: "showMap", sender: matches)
    }
    
    
    @IBAction func showPhotosButtonPressed(_ sender: UIButton) {
        var matchesWithPhoto = [Match]()
        do {
            let request = NSFetchRequest<Match>(entityName: "Match")
            request.predicate = NSPredicate(format: "image != NIL", argumentArray: nil)
            matchesWithPhoto = try managedContext.fetch(request)
            print(matchesWithPhoto.map({$0.game?.name}))
        } catch {
            print("Error fetching matches")
        }
        performSegue(withIdentifier: "showPhotos", sender: matchesWithPhoto)
    }
    
    @IBAction func PVPButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "choosePlayers", sender: nil)
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
            
            //If timer is over 1 minute, then set the time of addMatchController to that value (in minutes)
            if timer.time > 60 {
                addMatchController.time = timer.time - timer.time.truncatingRemainder(dividingBy: 60)
            }
        case "showMap"?:
            let controller = segue.destination as! MapViewController
            controller.matches = sender as! [Match]
        case "showPhotos"?:
            let controller = segue.destination as! PhotosViewController
            controller.matches = sender as! [Match]
        case "choosePlayers"?:
            let controller = segue.destination as! ChooserViewController
            controller.segueKey = "PVP"
            do {
                controller.availablePlayers = try managedContext.fetch(Player.fetchRequest())
                controller.selectedPlayers = [Player]()
            } catch {
                print("Error fetching players")
            }
        case "test"?:
            print("Test")
        default:
            preconditionFailure("Wrong segue identifier")
        }
    }
    
    
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
