//
//  MyTimer.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 09/02/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//

import UIKit

//Class to manage timer in home screen
class MyTimer {
    
    
    var timer = Timer()
    var time = TimeInterval(exactly: 0)!
    var isRunning = false
    
    //label needed to update
    var label: UILabel?

    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        isRunning = true
    }
    
    func stopTimer() {
        timer.invalidate()
        isRunning = false
    }
    
    func resetTimer() {
        timer.invalidate()
        time = 0
        label?.text = time.toStringWithSeconds()
        isRunning = false
    }
    
    @objc private func updateTimer() {
        time = time + 1
        label?.text = time.toStringWithSeconds()
    }
    
    func saveTimer() {
        UserDefaults.standard.set(isRunning, forKey: "isRunning")
        if isRunning {
            let date = Date(timeInterval: -time, since: Date())
            UserDefaults.standard.set(date, forKey: "date")
        } else {
            UserDefaults.standard.set(time, forKey: "time")
        }
        stopTimer()
    }
    
    func loadTimer() {
        isRunning = UserDefaults.standard.bool(forKey: "isRunning")
        if isRunning {
            guard let date = UserDefaults.standard.object(forKey: "date") as? Date else { return }
            //Time is time between current date and saved date
            time = TimeInterval(exactly: Date().timeIntervalSince(date))!
            runTimer()
        } else {
            guard let savedTime = UserDefaults.standard.object(forKey: "time") as? TimeInterval else { return }
            time = savedTime
        }
    }
}
