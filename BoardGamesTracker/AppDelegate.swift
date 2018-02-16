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

    let playerStore = PlayerStore()
    let gameStore = GameStore()
    
    var timer = MyTimer()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        timer = MyTimer()
        timer.loadTimer()
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
        
        gameStore.playerStore = playerStore
        gameStore.setPlayerStore()
        
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        for player in playerStore.allPlayers {
            if player.name == "" {
                player.name = "Change me!"
            }
        }
        timer.saveTimer()
        if gameStore.save() && playerStore.save() {
            print("Successfully saved all files")
        }
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

}

