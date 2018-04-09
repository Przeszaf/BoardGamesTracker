//
//  PlayerVersusPlayerViewController.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 04/04/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//

import UIKit
import CoreData

class PVPViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tableView: UITableView!
    var firstPlayer: Player!
    var secondPlayer: Player!
    var matches: [Match]!
    var results = [(PlayerResult, PlayerResult)]()
    
    var managedContext: NSManagedObjectContext!
    
    //MARK: - Lifecycle of VC
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedContext = appDelegate.persistentContainer.viewContext
        
        //Fetch all matches where both player participated sorted by date
        do {
            let request = NSFetchRequest<Match>(entityName: "Match")
            request.predicate = NSPredicate(format: "ANY players == %@ AND ANY players == %@", firstPlayer, secondPlayer)
            let sortDateDescriptor = NSSortDescriptor(key: "date", ascending: false)
            request.sortDescriptors = [sortDateDescriptor]
            
            matches = try managedContext.fetch(request)
        } catch {
            print("Error fetching matches")
        }
        
        //Calculate wins of both players
        var firstPlayerWins = 0
        var secondPlayerWins = 0
        for match in matches {
            var firstPlayerResult: PlayerResult!
            var secondPlayerResult: PlayerResult!
            for playerResult in match.results?.allObjects as! [PlayerResult] {
                if playerResult.player == firstPlayer {
                    firstPlayerResult = playerResult
                } else if playerResult.player == secondPlayer {
                    secondPlayerResult = playerResult
                }
            }
            if firstPlayerResult.place < secondPlayerResult.place {
                firstPlayerWins += 1
            } else if firstPlayerResult.place > secondPlayerResult.place {
                secondPlayerWins += 1
            }
            results.append((firstPlayerResult, secondPlayerResult))
        }
        
        
        //If there are no matches in common, then display another view
        if matches.count == 0 {
            let label = UILabel(frame: view.frame)
            label.textAlignment = .center
            label.text = "You do not have matches in common :("
            view.addSubview(label)
            return
            //Else create tableView
        } else {
            tableView = UITableView(frame: view.frame, style: .plain)
            view.addSubview(tableView)
        }
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(PVPCell.self, forCellReuseIdentifier: "PVPCell")
        
        //Create Header View
        let headerView = PVPHeaderView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50))
        headerView.firstPlayerNameLabel.text = firstPlayer.name!
        headerView.secondPlayerNameLabel.text = secondPlayer.name!
        headerView.firstPlayerScoreLabel.text = String(firstPlayerWins)
        headerView.secondPlayerScoreLabel.text = String(secondPlayerWins)
        
        //Different colours and gradients depending on which player won
        if firstPlayerWins > secondPlayerWins {
            headerView.firstPlayerNameLabel.textColor = UIColor.green
            headerView.secondPlayerNameLabel.textColor = UIColor.red
            configureGradient(leftColor: UIColor(red: 0.1, green: 0.6, blue: 0.1, alpha: 0.6), rightColor: UIColor(red: 0.6, green: 0.1, blue: 0.1, alpha: 0.6))
        } else if firstPlayerWins < secondPlayerWins {
            headerView.firstPlayerNameLabel.textColor = UIColor.red
            headerView.secondPlayerNameLabel.textColor = UIColor.green
            configureGradient(leftColor: UIColor(red: 0.6, green: 0.2, blue: 0.3, alpha: 0.6), rightColor: UIColor(red: 0.1, green: 0.6, blue: 0.1, alpha: 0.6))
        } else {
            configureGradient(leftColor: UIColor(red: 0.1, green: 0.3, blue: 0.7, alpha: 0.6), rightColor: UIColor(red: 0.3, green: 0.1, blue: 0.7, alpha: 0.6))
        }
        tableView.tableHeaderView = headerView
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PVPCell", for: indexPath) as! PVPCell
        let result = results[indexPath.row]
        //Depending on who won, there is different Cell Background View
        if result.0.place > result.1.place {
            cell.firstPlayerResultLabel.textColor = UIColor.white
            cell.secondPlayerResultLabel.textColor = UIColor.white
            cell.backgroundView = PVPCellBackgroundView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: cell.frame.height), leftColor: UIColor.red, rightColor: UIColor.green)
        } else if result.0.place < result.1.place {
            cell.secondPlayerResultLabel.textColor = UIColor.white
            cell.firstPlayerResultLabel.textColor = UIColor.white
            cell.backgroundView = PVPCellBackgroundView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: cell.frame.height), leftColor: UIColor(red: 0.2, green: 1, blue: 0.2, alpha: 1), rightColor: UIColor(red: 1, green: 0.2, blue: 0.2, alpha: 1))
        } else {
            cell.secondPlayerResultLabel.textColor = UIColor.white
            cell.firstPlayerResultLabel.textColor = UIColor.white
            cell.backgroundView = PVPCellBackgroundView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: cell.frame.height), leftColor: UIColor(red: 0, green: 0.5, blue: 1, alpha: 1), rightColor: UIColor(red: 0.5, green: 0, blue: 1, alpha: 1))
        }
        cell.backgroundColor = UIColor.clear
        
        //Place string is different if there are points in match
        var placeString = ""
        switch result.0.place {
        case 1:
            placeString = "1st"
        case 2:
            placeString = "2nd"
        case 3:
            placeString = "3rd"
        default:
            placeString = "\(result.0.place)th"
        }
        if result.0.point != 0 {
            cell.firstPlayerResultLabel.text = "\(placeString) - \(result.0.point) pts"
        } else {
            cell.firstPlayerResultLabel.text = "\(placeString) place"
        }
        
        placeString = ""
        switch result.1.place {
        case 1:
            placeString = "1st"
        case 2:
            placeString = "2nd"
        case 3:
            placeString = "3rd"
        default:
            placeString = "\(result.1.place)th"
        }
        if result.1.point != 0 {
            cell.secondPlayerResultLabel.text = "\(placeString) - \(result.1.point) pts"
        } else {
            cell.secondPlayerResultLabel.text = "\(placeString) place"
        }
        
        cell.dateLabel.text = matches[indexPath.row].date?.toString()
        
        cell.gameImageView.image = UIImage(named: matches[indexPath.row].game!.name!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matches.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    //MARK: - Other Functions
    
    func configureGradient(leftColor: UIColor, rightColor: UIColor) {
        let gradientBackgroundColors = [leftColor.cgColor, rightColor.cgColor]
        let gradientLocations: [NSNumber] = [0.0,1.0]
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientBackgroundColors
        gradientLayer.locations = gradientLocations
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        
        gradientLayer.frame = tableView.bounds
        let backgroundView = UIView(frame: tableView.bounds)
        backgroundView.layer.insertSublayer(gradientLayer, at: 0)
        tableView.backgroundView = backgroundView
    }
}
