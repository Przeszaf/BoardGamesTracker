//
//  AddMatchViewController.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 18/01/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//

import UIKit
import CoreLocation

class AddMatchViewController: UIViewController, UITextViewDelegate, CLLocationManagerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var gameStore: GameStore!
    var playerStore: PlayerStore!
    var imageStore: ImageStore!
    
    var locationManager = CLLocationManager()
    
    //MARK: - Variables needed to create a new match
    var selectedGame: Game?
    var selectedPlayers = [Player]()
    var availablePlayers = [Player]()
    var date: Date?
    var time: TimeInterval?
    var location: CLLocation?
    
    //Used to pass correct values to ChoosePlayersViewController
    var segueKey: String?
    
    //Needed for team games without points
    var winners = [Player]()
    var loosers = [Player]()
    
    //Needed for solo games with points
    var playersPoints = [Player: Int]()
    var deselectedPlayers = [Player]()
    
    //Needed for solo games with places
    var playersPlaces = [Player: Int]()
    
    //For custom matches
    var playersClasses = [Player: Any]()
    var dictionary = [String: Any]()
    
    //Workaround of double segues
    var dateSinceSegue = Date(timeIntervalSinceNow: -1)
    
    //Pickers
    let picker = UIDatePicker()
    
    //MARK: - Outlets: text fields and stack views
    
    var myView: AddMatchView!
    
    var imageView: UIImageView!
    
    //MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        loadView()
        
        myView.gameTextView.delegate = self
        myView.playersTextView.delegate = self
        myView.winnersTextView.delegate = self
        myView.loosersTextView.delegate = self
        myView.pointsTextView.delegate = self
        myView.dateTextView.delegate = self
        myView.timeTextView.delegate = self
        myView.dictionaryTextView.delegate = self
        
        
        //At the beginning show only stack views below
        myView.gameStackView.isHidden = false

        
        tabBarController?.tabBar.isHidden = true
        
        myView.dateTextView.inputView = picker
        myView.timeTextView.inputView = picker
        picker.addTarget(self, action: #selector(pickerChanged(_:)), for: .valueChanged)
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(cancelPicker))
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(donePicker))
        let toolbar = MyToolbar.createToolbarWith(leftButton: cancelButton, rightButton: doneButton)
        myView.dateTextView.inputAccessoryView = toolbar
        myView.timeTextView.inputAccessoryView = toolbar
        
        date = Date()
        if time == nil {
            time = TimeInterval(exactly: 0)
        }
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        myView.gameTextView.text = selectedGame?.name
        availablePlayers = playerStore.allPlayers
        
        //Update visibility of stack views
        myView.hideAllStackViews()
        myView.gameStackView.isHidden = false
        
        
        updateTextViews()
        
        if let game = selectedGame {
            myView.dateStackView.isHidden = false
            myView.timeStackView.isHidden = false
            myView.locationStackView.isHidden = false
            imageView.isHidden = false
            myView.dateTextView.text = date?.toStringWithHour()
            myView.timeTextView.text = time?.toString()
            if game.type == .TeamWithPlaces {
                myView.winnersStackView.isHidden = false
                myView.loosersStackView.isHidden = false
            } else if game.type == .SoloWithPoints {
                myView.playersStackView.isHidden = false
                myView.pointsStackView.isHidden = false
                myView.pointsLabel.tag = 0
            } else if game.type == .SoloWithPlaces {
                myView.playersStackView.isHidden = false
                myView.pointsLabel.text = "Places"
                myView.pointsLabel.tag = 1
                myView.pointsStackView.isHidden = false
            } else if game.type == .Cooperation {
                myView.playersStackView.isHidden = false
                myView.switchStackView.isHidden = false
            }
            
            if let customGame = game as? CustomGame {
                if customGame.name == "Avalon" {
                    myView.dictionaryStackView.isHidden = false
                    myView.switchTwoStackView.isHidden = false
                    myView.switchTwoLabel.text = "Playing with lady of the Lake?"
                    if winners.count < loosers.count {
                        myView.switchStackView.isHidden = false
                        myView.switchLabel.text = "Merlin killed by Assassin?"
                    }
                }
            }
        }
        
        if imageView.image == nil {
            imageView.contentMode = .center
            imageView.backgroundColor = UIColor.lightGray
            imageView.image = UIImage(named: "camera")
        } else if imageView.image != UIImage(named: "camera") {
            imageView.contentMode = .scaleAspectFit
            imageView.backgroundColor = nil
        }
    }
    
    override func loadView() {
        super.loadView()
        myView = AddMatchView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        view.addSubview(myView)
        myView.translatesAutoresizingMaskIntoConstraints = false
        myView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        myView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive = true
        myView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor).isActive = true
        myView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
        imageView = myView.imageView
    }
    
    //MARK: - UITextView
    
    //Pressing the text view will perform a segue
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        //Set correct segueKey for choosePlayers segue
        if textView == myView.playersTextView {
            segueKey = "all"
        } else if textView == myView.winnersTextView {
            segueKey = "winners"
        } else if textView == myView.loosersTextView {
            segueKey = "loosers"
        }
        //Workaround for double segues - if time between segues is lower than 0.1 second,
        //then do not perform segue
        if Float(dateSinceSegue.timeIntervalSinceNow) < -0.1 {
            if textView == myView.pointsTextView {
                performSegue(withIdentifier: "addPoints", sender: self)
            } else if textView == myView.playersTextView || textView == myView.loosersTextView || textView == myView.winnersTextView {
                performSegue(withIdentifier: "choosePlayers", sender: self)
            } else if textView == myView.gameTextView {
                performSegue(withIdentifier: "chooseGame", sender: self)
            } else if textView == myView.dictionaryTextView {
                performSegue(withIdentifier: "addClasses", sender: self)
            }
        }
        dateSinceSegue = Date()
        
        //set correct picker mode
        if textView == myView.dateTextView {
            picker.datePickerMode = .dateAndTime
            picker.maximumDate = Date()
            return true
        } else if textView == myView.timeTextView {
            picker.datePickerMode = .countDownTimer
            return true
        }
        return false
        
    }
    
    
    //MARK: - Managing segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "chooseGame"?:
            let controller = segue.destination as! ChooseGameViewController
            controller.gameStore = gameStore
            controller.selectedGame = selectedGame
        case "choosePlayers"?:
            let controller = segue.destination as! ChoosePlayersViewController
            controller.key = segueKey
            updateAvailablePlayers()
            switch segueKey {
            case "all"?:
                controller.availablePlayers = availablePlayers
                controller.selectedPlayers = selectedPlayers
                if let game = selectedGame {
                    controller.maxPlayers = game.maxNoOfPlayers
                }
            case "winners"?:
                controller.availablePlayers = availablePlayers
                controller.selectedPlayers = winners
                if let game = selectedGame {
                    controller.maxPlayers = game.maxNoOfPlayers - loosers.count
                }
            case "loosers"?:
                controller.availablePlayers = availablePlayers
                controller.selectedPlayers = loosers
                if let game = selectedGame {
                    controller.maxPlayers = game.maxNoOfPlayers - winners.count
                }
            default:
                preconditionFailure("Wrong segue key")
            }
        case "addPoints"?:
            let controller = segue.destination as! AddPointsViewController
            //Updates dictionary, so it holds only selectedPlayers
            updateDictionary()
            controller.availablePlayers = selectedPlayers
            if myView.pointsLabel.tag == 0 {
                controller.playersPoints = playersPoints
                controller.key = "Points"
            } else if myView.pointsLabel.tag == 1 {
                controller.key = "Places"
                controller.playersPlaces = playersPlaces
            }
        case "addClasses"?:
            let controller = segue.destination as! AddClassesViewController
            controller.winners = winners
            controller.loosers = loosers
            controller.game = selectedGame
            controller.playersClasses = playersClasses
        default:
            preconditionFailure("Wrong segue identifier")
        }
    }
    
    //MARK: - Buttons
    @IBAction func addMatchButtonPressed(_ sender: UIBarButtonItem) {
        //There must be a game chosen
        guard let game = selectedGame else {
            createFailureAlert(with: "Choose a game")
            return
        }
        
        if time == TimeInterval(exactly: 0) {
            createFailureAlert(with: "Choose time of game")
            return
        }
        
        
        var places = [Int]()
        var players = [Player]()
        var points = [Int]()
        var match: Match?
        
        //Update places, players and points variables according to game type
        
        
        //When team with places game, then the winners and loosers fields cannot be empty
        if game.type == .TeamWithPlaces {
            if winners.isEmpty {
                createFailureAlert(with: "Winners field cannot be empty!")
                return
            } else if loosers.isEmpty {
                createFailureAlert(with: "Loosers field cannot be empty")
                return
            }
            
            //And there are only 2 places - 1st and 2nd i.e. you either win with your team or lose
            players = winners + loosers
            for _ in winners {
                places.append(1)
            }
            for _ in loosers {
                places.append(2)
            }
        }
        
        //When plaing solo game with points, then must select players and assign points to all players
        if game.type == .SoloWithPoints {
            if selectedPlayers.isEmpty {
                createFailureAlert(with: "Players field cannot be empty!")
                return
            } else if !arePointsAssigned() {
                createFailureAlert(with: "All players must have points assigned!")
                return
            }
            
            //Choose correct order - ascending (higher points win) or descending (lower points win)
            players = selectedPlayers
            points = sortPlayersPoints(players: &players, pointsDict: playersPoints, order: "ascending")
            places = assignPlayersPlaces(points: points)
        }
        
        if game.type == .SoloWithPlaces {
            if selectedPlayers.isEmpty {
                createFailureAlert(with: "Players field cannot be empty!")
                return
            } else if !arePlacesAssigned() {
                createFailureAlert(with: "All players must have points assigned!")
                return
            }
            
            players = selectedPlayers
            for player in players {
                places.append(playersPlaces[player]!)
            }
        }
        
        if game.type == .Cooperation {
            players = selectedPlayers
            
            for _ in players {
                if myView.mySwitch.isOn {
                    places.append(1)
                } else {
                    places.append(2)
                }
            }
        }
        
        //If there are no errors, then create match and display success alert
        
        //If custom game, then create CustomMatch
        if let customGame = selectedGame as? CustomGame {
            if customGame.name == "Avalon" {
                
                //Merlin can be only killed when bad guys win the game and
                //there are always less bad guys than good guys.
                if loosers.count > winners.count {
                    dictionary["Killed by Assassin?"] = myView.mySwitch.isOn
                }
                dictionary["Lady of the lake?"] = myView.mySwitchTwo.isOn
                match = CustomMatch(game: game, players: players, playersPoints: nil, playersPlaces: places, date: date!, time: time!, location: location, dictionary: dictionary, playersClasses: playersDictionaryToCodable(playersClasses))
            }
            //Else create normal Match
        } else if game.type == .TeamWithPlaces || game.type == .SoloWithPlaces || game.type == .Cooperation {
            match = Match(game: game, players: players, playersPoints: nil, playersPlaces: places, date: self.date!, time: self.time!, location: self.location)
        } else if game.type == .SoloWithPoints {
            match = Match(game: game, players: players, playersPoints: points, playersPlaces: places, date: self.date!, time: self.time!, location: self.location)
        }
        game.addMatch(match: match!)
        
        //If image was changed from default, then setImage
        if imageView.image != UIImage(named: "camera") {
            imageStore.setImage(image: imageView.image!, forKey: match!.imageKey)
        }
        
        createSuccessAlert(with: "Created \(game.name)")
        playerStore.allPlayers.sort()
        return
    }
    
    //MARK: - Custom functions
    
    //Removes players that were already choosen as winners/loosers from availablePlayers array
    func updateAvailablePlayers() {
        availablePlayers = playerStore.allPlayers
        if segueKey == "loosers" {
            for winner in winners {
                let index = availablePlayers.index(of: winner)
                availablePlayers.remove(at: index!)
            }
        } else if segueKey == "winners" {
            for looser in loosers {
                let index = availablePlayers.index(of: looser)
                availablePlayers.remove(at: index!)
            }
        }
    }
    
    //Updates playersPoints and playersPlaces dictionaries - sets playersPlaces and playersPoints to 0 for selectedPlayers
    //And deletes deselectedPlayers from dictionary
    func updateDictionary() {
        if myView.pointsLabel.tag == 0 {
            for player in selectedPlayers {
                if playersPoints[player] == nil {
                    playersPoints[player] = 0
                }
            }
            for player in deselectedPlayers {
                playersPoints[player] = nil
            }
        } else if myView.pointsLabel.tag == 1 {
            for player in selectedPlayers {
                if playersPlaces[player] == nil {
                    playersPlaces[player] = 0
                }
            }
            for player in deselectedPlayers {
                playersPlaces[player] = nil
            }
        }
    }
    
    //Updates textViews
    func updateTextViews() {
        myView.playersTextView.text = selectedPlayers.map{$0.name}.joined(separator: ", ")
        myView.winnersTextView.text = winners.map{$0.name}.joined(separator: ", ")
        myView.loosersTextView.text = loosers.map{$0.name}.joined(separator: ", ")
        var string = [String]()
        for player in selectedPlayers {
            if myView.pointsLabel.tag == 0 {
                string.append("\(player.name): \(playersPoints[player] ?? 0)")
            } else if myView.pointsLabel.tag == 1 {
                if let place = playersPlaces[player] {
                    if place == 0 {
                        string.append("\(player.name)")
                    } else {
                        string.append("\(place). \(player.name)")
                    }
                }
            }
        }
        myView.pointsTextView.text = string.joined(separator: ", ")
        locationManager.locationToString(location: location, textView: myView.locationTextView)
        
        //Creates strings for custom games
        string.removeAll()
        if let customGame = selectedGame as? CustomGame {
            if customGame.name == "Avalon" {
                let classesDictionary = playersClasses as! [Player: AvalonClasses]
                for player in winners + loosers {
                    string.append("\(player) - \(classesDictionary[player]?.rawValue ?? "none")")
                }
            }
        }
        myView.dictionaryTextView.text = string.joined(separator: ", ")
    }
    
    
    //Function sorts players by amount of points, either ascending or descending, returning the points array
    func sortPlayersPoints(players: inout [Player], pointsDict: [Player: Int], order key: String) -> [Int] {
        var points = [Int]()
        for player in players {
            let point = pointsDict[player]
            points.append(point!)
        }
        var newPlayers = [Player]()
        var newPoints = [Int]()
        switch key {
        case "ascending":
            for _ in 0..<players.count {
                let max = points.max()!
                let index = points.index(of: max)!
                newPlayers.append(players[index])
                newPoints.append(points[index])
                points[index] = -1
            }
        case "descending":
            for _ in 0..<players.count {
                let min = points.min()!
                let index = points.index(of: min)!
                newPlayers.append(players[index])
                newPoints.append(points[index])
                points[index] = 1000
            }
        default:
            preconditionFailure("Wrong order key")
        }
        players = newPlayers
        return newPoints
    }
    
    //Function takes points array (MUST BE SORTED!!) as an argument and return places
    func assignPlayersPlaces(points: [Int]) -> [Int] {
        if points.sorted(by: {$0 > $1}) != points {
            preconditionFailure("Points not sorted when assigning places!")
        }
        
        var places = [Int].init(repeating: 0, count: points.count)
        //Sets place of first player to 1
        places[0] = 1
        for i in 1..<points.count {
            //If current and previous players have same amount of points, then
            //set place of current player to place of previous player.
            //points = [30, 27, 27, 25, 23, 21, 21] -> places = [1, 2, 2, 4, 5, 6, 6]
            if points[i] == points[i-1] {
                places[i] = places[i-1]
            } else {
                places[i] = i+1
            }
        }
        return places
    }
    
    //Sorts players according to playersPlaces dictionary
    func sortPlayersPlaces(players: inout [Player], places: [Player: Int]) {
        players.sort { (p1, p2) -> Bool in
            if playersPlaces[p1]! == 0 {
                return false
            } else if playersPlaces[p2]! == 0 {
                return true
            } else if playersPlaces[p1]! < playersPlaces[p2]! {
                return true
            }
            return false
        }
    }
    
    //Checks if all players in playersPoints dictionary have points assigned
    func arePointsAssigned() -> Bool {
        for player in selectedPlayers {
            if playersPoints[player] == 0 {
                return false
            }
        }
        return true
    }
    
    //Checks if all selectedPlayers are in playersPlaces dictionary and have places assigned
    func arePlacesAssigned() -> Bool {
        for player in selectedPlayers {
            if playersPlaces[player] == 0 {
                return false
            }
        }
        return true
    }
    
    //Turns [Player: Any] into [String: Any] by using playerID instead of direct reference to Player as key
    func playersDictionaryToCodable(_ playersClasses: [Player: Any]) -> [String: Any] {
        var codablePlayersClasses = [String: Any]()
        for (player, any) in playersClasses {
            codablePlayersClasses[player.playerID] = any
        }
        return codablePlayersClasses
    }
    
    //Clears fields of textViews
    func clearFields() {
        myView.gameTextView.text = ""
        myView.playersTextView.text = ""
        myView.winnersTextView.text = ""
        myView.loosersTextView.text = ""
        myView.pointsTextView.text = ""
    }
    //MARK: - Alerts
    
    //Success alert with given string that disappears after 1 second and pops to previous controller
    func createSuccessAlert(with string: String) {
        let alert = MyAlerts.createAlert(title: "Success!", message: string)
        self.myView.timeTextView.resignFirstResponder()
        self.present(alert, animated: true, completion: nil)
        let time = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: time) {
            alert.dismiss(animated: true, completion: {
                self.navigationController?.popToRootViewController(animated: true)
            })
        }
    }
    
    //Failure alert with given string
    func createFailureAlert(with string: String) {
        let alert = MyAlerts.createAlert(title: "Failure!", message: string)
        alert.addAction(UIAlertAction(title: "Ok!", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: - Picker's toolbar
    
    //PickerView Toolbar button functions
    
    //Checks which picker mode is chosen and accordingly updates correct views and variables
    //And resigns first responder
    @objc func donePicker() {
        if picker.datePickerMode == .countDownTimer {
            time = picker.countDownDuration
            myView.timeTextView.text = time?.toString()
            myView.timeTextView.resignFirstResponder()
        } else if picker.datePickerMode == .dateAndTime {
            date = picker.date
            myView.dateTextView.text = date?.toStringWithHour()
            myView.dateTextView.resignFirstResponder()
        }
    }
    
    //If cancel picker, then accordingly reverts correct views to default values
    //And resigns first responder
    @objc func cancelPicker() {
        if picker.datePickerMode == .countDownTimer {
            time = TimeInterval(exactly: 60)
            myView.timeTextView.text = time?.toString()
            myView.timeTextView.resignFirstResponder()
        } else if picker.datePickerMode == .dateAndTime {
            date = Date()
            myView.dateTextView.text = date?.toStringWithHour()
            myView.dateTextView.resignFirstResponder()
        }
        picker.resignFirstResponder()
    }
    
    //If picker value is changed, then update views and variables
    @objc func pickerChanged(_ sender: UIDatePicker) {
        if sender.datePickerMode == .countDownTimer {
            myView.timeTextView.text = sender.countDownDuration.toString()
            time = sender.countDownDuration
        } else if sender.datePickerMode == .dateAndTime {
            myView.dateTextView.text = sender.date.toStringWithHour()
            date = sender.date
        }
    }
    
    
    //MARK: - Image handling
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
        } else {
            imagePicker.sourceType = .photoLibrary
        }
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageView.image = image
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Location
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.first
        updateTextViews()
    }
}
