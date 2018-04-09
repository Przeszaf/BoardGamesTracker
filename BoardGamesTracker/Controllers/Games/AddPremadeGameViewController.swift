//
//  AddPremadeGameViewController.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 22/02/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//

import UIKit
import CoreData

class AddPremadeGameViewController: UITableViewController {
    

    var premadeGames: [Game]!
    
    var managedContext: NSManagedObjectContext!
    
    //MARK: - ViewController functions
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(PremadeGamesCell.self, forCellReuseIdentifier: "PremadeGamesCell")
        navigationItem.title = "Premade games"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addMyOwnGame))
        
        tableView.backgroundColor = Constants.Global.backgroundColor
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedContext = appDelegate.persistentContainer.viewContext
        
        
        //Fetch all games that are not in collection, sorted by name
        do {
            let request = NSFetchRequest<Game>(entityName: "Game")
            request.predicate = NSPredicate(format: "inCollection == NO", argumentArray: nil)
            request.sortDescriptors = [NSSortDescriptor.init(key: "name", ascending: true)]
            premadeGames = try managedContext.fetch(request)
        } catch {
            print(error)
        }
    }
    
    
    //MARK: - TableView
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PremadeGamesCell", for: indexPath) as! PremadeGamesCell
        cell.gameNameLabel.text = premadeGames[indexPath.row].name
        cell.gameTypeLabel.text = premadeGames[indexPath.row].type
        cell.gameIconImageView.image = UIImage(named: premadeGames[indexPath.row].name!)
        
        cell.backgroundColor = UIColor.clear
        cell.backgroundView = CellBackgroundView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: cell.frame.height))
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return premadeGames.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = premadeGames[indexPath.row].name!.height(withConstrainedWidth: tableView.frame.width - 60, font: UIFont.systemFont(ofSize: 17))
        return height + 35
    }
    
    //If game is selected, then adds it to allGames in gameStore and removes from premadeGames
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let game = premadeGames[indexPath.row]
        game.inCollection = true
        premadeGames.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        do {
            try managedContext.save()
        } catch {
            print(error)
        }
    }
    
    
    
    
    //MARK: - Segues
    @objc func addMyOwnGame() {
        performSegue(withIdentifier: "addGame", sender: self)
    }
    
}

