//
//  AppDelegate.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 09/01/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    let gameStore = GameStore()
    let playerStore = PlayerStore()
    
    var timer = MyTimer()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        timer = MyTimer()
        //Using AppDelegate to create store object models in view controllers.
        
        let tabBarController = window?.rootViewController as! UITabBarController
        
        let navControllerMatches = tabBarController.viewControllers?[0] as! UINavigationController
        let homeController = navControllerMatches.topViewController as! HomeViewController
        
        let navControllerGames = tabBarController.viewControllers?[1] as! UINavigationController
        let allGamesController = navControllerGames.topViewController as! AllGamesViewController
        
        let navControllerPlayers = tabBarController.viewControllers?[2] as! UINavigationController
        let allPlayersController = navControllerPlayers.topViewController as! AllPlayersViewController
        
        allGamesController.gameStore = gameStore
        allPlayersController.playerStore = playerStore
        homeController.gameStore = gameStore
        homeController.playerStore = playerStore
        homeController.timer = timer
        
        addMatches()
        
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

    //MARK: - Custom functions
    func addMatches() {
        let player = Player(name: "przemek")
        let player2 = Player(name: "Daria")
        let player3 = Player(name: "Koksu")
        let player4 = Player(name: "Igor")
        
        
        playerStore.addPlayer(player)
        playerStore.addPlayer(player2)
        playerStore.addPlayer(player3)
        playerStore.addPlayer(player4)
        
        let game = Game(name: "Avalon", type: .TeamWithPlaces, maxNoOfPlayers: 10)
        let game2 = Game(name: "Dixit", type: .SoloWithPoints, maxNoOfPlayers: 12)
        
        gameStore.addGame(game)
        gameStore.addGame(game2)
        
        let match = Match(game: game, players: playerStore.allPlayers, playersPoints: nil, playersPlaces: [1, 1, 2, 2], date: Date(), time: TimeInterval(exactly: 2400)!)
        let match2 = Match(game: game2, players: playerStore.allPlayers, playersPoints: [30, 25, 20, 14], playersPlaces: [1, 2, 3, 4], date: Date(), time: TimeInterval(exactly: 3600)!)
        let match3 = Match(game: game, players: [player, player2], playersPoints: nil, playersPlaces: [1, 1, 2], date: Date.init(timeIntervalSince1970: 0), time: TimeInterval(exactly: 2580)!)
        
        match.game?.addMatch(match: match)
        match2.game?.addMatch(match: match2)
        match3.game?.addMatch(match: match3)
        playerStore.allPlayers.sort()

    }

}

