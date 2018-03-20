//
//  AppDelegate.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 09/01/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    
    var timer = MyTimer()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        timer = MyTimer()
        timer.loadTimer()
        //Using AppDelegate to create store object models in view controllers.
        
        let tabBarController = window?.rootViewController as! UITabBarController
        
        let navControllerMatches = tabBarController.viewControllers?[0] as! UINavigationController
        let homeController = navControllerMatches.topViewController as! HomeViewController
        
        homeController.timer = timer
        
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print("Core data")
        print(urls[urls.count-1] as URL)
        
        
        let managedContext = persistentContainer.viewContext

        do {
            let players: [Player] = try managedContext.fetch(Player.fetchRequest())
            print(players.map({$0.name!}).joined(separator: ", "))
            if players.count == 0 {
                let playerEntity = NSEntityDescription.entity(forEntityName: "Player", in: managedContext)!
                for i in 0..<7 {
                    let player = Player(entity: playerEntity, insertInto: managedContext)
                    switch i {
                    case 0:
                        player.name = "Przemek"
                    case 1:
                        player.name = "Daria"
                    case 2:
                        player.name = "Igor"
                    case 3:
                        player.name = "Koksu"
                    case 4:
                        player.name = "Marzena"
                    case 5:
                        player.name = "Robert"
                    case 6:
                        player.name = "Sagan"
                    default:
                        player.name = "Other name"
                    }
                }
                let anotherPlayer = Player(context: managedContext)
                anotherPlayer.name = "Kinga"
                try managedContext.save()
            }

            let avalon = Game(context: managedContext)
            avalon.name = "Avalon"

            for i in 0..<7 {
                let avalonClass = GameClass(context: managedContext)
                avalon.addToClasses(avalonClass)
                switch i {
                case 0:
                    avalonClass.name = "Merlin"
                    avalonClass.type = ClassType.Good
                case 1:
                    avalonClass.name = "Loyal Servant of Arthur"
                    avalonClass.type = ClassType.Good
                case 2:
                    avalonClass.name = "Percival"
                    avalonClass.type = ClassType.Good
                case 3:
                    avalonClass.name = "Minion of Mordred"
                    avalonClass.type = ClassType.Evil
                case 4:
                    avalonClass.name = "Mordred"
                    avalonClass.type = ClassType.Evil
                case 5:
                    avalonClass.name = "Assassin"
                    avalonClass.type = ClassType.Evil
                case 6:
                    avalonClass.name = "Morgana"
                    avalonClass.type = ClassType.Evil
                default:
                    avalonClass.name = "Other"
                }
            }

            avalon.type = GameType.TeamWithPlaces

            let avalonExpansion = Expansion(context: managedContext)
            avalonExpansion.name = "Lady of the Lake"

            avalon.addToExpansions(avalonExpansion)
            avalon.expansionsAreMultiple = true


            let request = NSFetchRequest<Player>(entityName: "Player")
            request.predicate = NSPredicate(format: "%K = %@ OR %K = %@", #keyPath(Player.name), "Daria", #keyPath(Player.name), "Przemek")

            let avalonPlayers = try managedContext.fetch(request)

            let avalonPlayersSet = NSSet(array: avalonPlayers)
            avalon.addToPlayers(avalonPlayersSet)
            print(avalonPlayers)

        } catch {
            print(error)
        }
        
        
        Helper.addGame(name: "Robinson Crusoe", type: GameType.Cooperation, maxNoOfPlayers: 10, pointsExtendedNameArray: nil, classesArray: ["Class1", "Class2", "Class3"], goodClassesArray: nil, evilClassesArray: nil, expansionsArray: ["Expansion1", "Expansion2"], expansionsAreMultiple: true, scenariosArray: ["Scenario1", "Scenario2"], scenariosAreMultiple: false, winSwitch: true, difficultyNames: ["Easy", "Medium", "Hard"], roundsLeftName: "Days", additionalSwitchName: "Playing with Friday", additionalSecondSwitchName: "Playing with Dog")
        
        
        let request = NSFetchRequest<Difficulty>(entityName: "Difficulty")
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(Difficulty.game.name), "Robinson Crusoe")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        
        do {
            let robinsonCrusoeDifficulties = try managedContext.fetch(request)
            print(robinsonCrusoeDifficulties.map({$0.name!}).joined(separator: ", "))
        } catch {
            print(error)
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        timer.saveTimer()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        timer.loadTimer()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "BoardGamesTracker")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    

}

