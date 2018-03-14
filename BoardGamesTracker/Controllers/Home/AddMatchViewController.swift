//
//  AddMatchViewController.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 18/01/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//

import UIKit
import CoreLocation

class AddMatchViewController: UIViewController, UITextViewDelegate, CLLocationManagerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    var gameStore: GameStore!
    var playerStore: PlayerStore!
    var imageStore: ImageStore!
    
    //Pickers
    let datePicker = UIDatePicker()
    let picker = UIPickerView()
    var pickerToolbar: UIToolbar!
    
    let pickerDataNumbers = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20]
    var pickerDifficultyNames: [String]!
    
    var locationManager = CLLocationManager()
    
    //MARK: - Variables needed to create a new match
    var selectedGame: Game?
    var selectedPlayers = [Player]()
    var availablePlayers = [Player]()
    var date: Date?
    var time: TimeInterval?
    var location: CLLocation?
    
    //Used to pass correct values to ChooserViewController
    var chooserSegueKey: String?
    var addInfoSegueKey: String?
    var addNumsSegueKey: String?
    
    //Needed for team games without points
    var winners = [Player]()
    var loosers = [Player]()
    
    //Needed for solo games with points
    var playersPoints = [Player: Int]()
    var deselectedPlayers = [Player]()
    
    //Needed for solo games with places
    var playersPlaces = [Player: Int]()
    
    //For custom matches
    var playersClasses = [Player: String]()
    var dictionary = [String: Any]()
    
    //Workaround of double segues
    var dateSinceSegue = Date(timeIntervalSinceNow: -1)
    
    //MARK: - Outlets: text fields and stack views
    
    var scrollView: UIScrollView!
    var myView: AddMatchView!
    var imageView: UIImageView!
    
    //MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        loadView()
        
        //Setting delegate of all textViews inside AddMatchView to AddMatchViewController
        for subview in myView.verticalStackView.arrangedSubviews {
            if let stackView = subview as? UIStackView {
                for stackViewSubview in stackView.arrangedSubviews {
                    if let textView = stackViewSubview as? UITextView {
                        textView.delegate = self
                    }
                }
            }
        }
        
        
        //At the beginning show only stack views below
        myView.hideAllStackViews()
        myView.gameStackView.isHidden = false
        
        tabBarController?.tabBar.isHidden = true
        
        //Creating date picker with toolbar
        myView.dateTextView.inputView = datePicker
        myView.timeTextView.inputView = datePicker
        datePicker.addTarget(self, action: #selector(pickerChanged(_:)), for: .valueChanged)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(cancelDatePicker))
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(doneDatePicker))
        let datePickerToolbar = Constants.Functions.createToolbarWith(leftButton: cancelButton, rightButton: doneButton)
        myView.dateTextView.inputAccessoryView = datePickerToolbar
        myView.timeTextView.inputAccessoryView = datePickerToolbar
        
        
        date = Date()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
        
        
        picker.delegate = self
        picker.dataSource = self
        let cancelPickerButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(cancelPicker))
        let donePickerButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(donePicker))
        pickerToolbar = Constants.Functions.createToolbarWith(leftButton: cancelPickerButton, rightButton: donePickerButton)
        
        view.backgroundColor = Constants.Global.backgroundColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        myView.gameTextView.text = selectedGame?.name
        availablePlayers = playerStore.allPlayers
        
        //Update visibility of stack views
        myView.hideAllStackViews()
        myView.gameStackView.isHidden = false
        
        imageView.isHidden = false
        if imageView.image == nil {
            imageView.contentMode = .center
            imageView.backgroundColor = UIColor.lightGray
            imageView.image = UIImage(named: "camera")
        } else if imageView.image != UIImage(named: "camera") {
            imageView.contentMode = .scaleAspectFit
            imageView.backgroundColor = nil
        }
        
        if selectedGame?.thereAreTeams == true {
            myView.winnersStackView.isHidden = false
            myView.loosersStackView.isHidden = false
        } else if selectedGame?.thereAreTeams == false {
            myView.playersStackView.isHidden = false
        }
        
        if selectedGame?.pointsExtendedNameArray != nil {
            myView.pointsExtendedStackView.isHidden = false
        } else if selectedGame?.thereArePoints == true {
            myView.pointsStackView.isHidden = false
        } else if selectedGame?.thereAreTeams == false {
            myView.placesStackView.isHidden = false
        }
        
        if selectedGame?.classesArray != nil {
            myView.classesStackView.isHidden = false
        }
        
        if selectedGame?.expansionsArray != nil {
            myView.expansionsStackView.isHidden = false
        }
        
        if selectedGame?.scenariosArray != nil {
            myView.scenariosStackView.isHidden = false
        }
        
        if selectedGame?.type == .Cooperation {
            myView.winSwitchStackView.isHidden = false
        }
        
        if let difficultyNames = selectedGame?.difficultyNames {
            pickerDifficultyNames = difficultyNames
            myView.difficultyStackView.isHidden = false
            myView.difficultyTextView.inputView = picker
            myView.difficultyTextView.inputAccessoryView = pickerToolbar
        }
        
        if let roundsName = selectedGame?.roundsLeftName {
            myView.roundsLeftStackView.isHidden = false
            myView.roundsLeftLabel.text = "\(roundsName) left?"
            myView.roundsLeftTextView.inputView = picker
            myView.roundsLeftTextView.inputAccessoryView = pickerToolbar
        }
        
        if let switchName = selectedGame?.additionalSwitchName {
            myView.additionalSwitchStackView.isHidden = false
            myView.additionalSwitchLabel.text = switchName + "?"
        }
        
        if let secondSwitchName = selectedGame?.additionalSecondSwitchName {
            myView.additionalSecondSwitchStackView.isHidden = false
            myView.additionalSecondSwitchLabel.text = secondSwitchName + "?"
        }
        
        updateTextViews()
    }
    
    override func loadView() {
        super.loadView()
        scrollView = UIScrollView(frame: view.frame)
        myView = AddMatchView(frame: view.frame)
        view.addSubview(scrollView)
        scrollView.addSubview(myView)
        
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        
        myView.translatesAutoresizingMaskIntoConstraints = false
        myView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 15).isActive = true
        myView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -15).isActive = true
        myView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -15).isActive = true
        myView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 15).isActive = true
        
        myView.verticalStackView.widthAnchor.constraint(equalToConstant: scrollView.frame.width - 30).isActive = true
        myView.imageView.heightAnchor.constraint(equalToConstant: myView.frame.width * 9 / 16).isActive = true
        imageView = myView.imageView
    }
    
    //MARK: - UITextView
    
    //Pressing the text view will perform a segue
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        //Set correct segueKey for chooser segue
        if textView == myView.playersTextView {
            chooserSegueKey = "all"
        } else if textView == myView.winnersTextView {
            chooserSegueKey = "winners"
        } else if textView == myView.loosersTextView {
            chooserSegueKey = "loosers"
        }
        //Workaround for double segues - if time between segues is lower than 0.1 second,
        //then do not perform segue
        if Float(dateSinceSegue.timeIntervalSinceNow) < -0.1 {
            if textView == myView.gameTextView {
                performSegue(withIdentifier: "chooseGame", sender: self)
            } else if textView == myView.playersTextView || textView == myView.loosersTextView || textView == myView.winnersTextView {
                performSegue(withIdentifier: "chooser", sender: self)
            } else if textView == myView.pointsTextView {
                addNumsSegueKey = "Points"
                performSegue(withIdentifier: "addNums", sender: self)
            } else if textView == myView.placesTextView {
                addNumsSegueKey = "Places"
                performSegue(withIdentifier: "addNums", sender: self)
            } else if textView == myView.pointsExtendedTextView {
                addNumsSegueKey = "Extended Points"
                performSegue(withIdentifier: "addNums", sender: self)
            } else if textView == myView.classesTextView {
                addInfoSegueKey = "Classes"
                performSegue(withIdentifier: "addInfo", sender: self)
            } else if textView == myView.expansionsTextView {
                chooserSegueKey = "Expansions"
                performSegue(withIdentifier: "chooser", sender: self)
            } else if textView == myView.scenariosTextView {
                chooserSegueKey = "Scenarios"
                performSegue(withIdentifier: "chooser", sender: self)
            } else if textView == myView.additionalTextView && selectedGame!.name == "Pandemic" {
                performSegue(withIdentifier: "addInfo", sender: self)
            }
        }
        dateSinceSegue = Date()
        
        //set correct date picker mode
        if textView == myView.dateTextView {
            datePicker.datePickerMode = .dateAndTime
            datePicker.maximumDate = Date()
            return true
        } else if textView == myView.timeTextView {
            datePicker.datePickerMode = .countDownTimer
            return true
        }
        
        
        if textView == myView.roundsLeftTextView {
            picker.tag = 1
            picker.reloadAllComponents()
            if textView.text == "" {
                textView.text = String(pickerDataNumbers[0])
                picker.selectRow(0, inComponent: 0, animated: false)
            } else {
                //Else go to already chosen option
                guard let num = Int(textView.text) else { return false }
                let index = pickerDataNumbers.index(of: num)
                picker.selectRow(index!, inComponent: 0, animated: false)
            }
            return true
        } else if textView == myView.difficultyTextView {
            picker.tag = 2
            picker.reloadAllComponents()
            if textView.text == "" {
                textView.text = pickerDifficultyNames[0]
                picker.selectRow(0, inComponent: 0, animated: false)
            } else {
                let index = pickerDifficultyNames.index(of: textView.text)
                picker.selectRow(index!, inComponent: 0, animated: false)
            }
            return true
        }
        
        return false
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return false
    }
    
    
    
    //MARK: - Managing segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "chooseGame"?:
            let controller = segue.destination as! ChooseGameViewController
            controller.gameStore = gameStore
            controller.selectedGame = selectedGame
        case "chooser"?:
            let controller = segue.destination as! ChooserViewController
            controller.segueKey = chooserSegueKey
            updateAvailablePlayers()
            switch chooserSegueKey {
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
            case "Expansions"?:
                controller.availableArray = (selectedGame?.expansionsArray)!
                controller.multipleAllowed = selectedGame?.expansionsAreMultiple
                if let selectedExpansions = dictionary["Expansions"] as? [String] {
                    controller.selectedArray = selectedExpansions
                }
            case "Scenarios"?:
                controller.availableArray = (selectedGame?.scenariosArray)!
                controller.multipleAllowed = selectedGame?.scenariosAreMultiple
                if let selectedScenarios = dictionary["Scenarios"] as? [String] {
                    controller.selectedArray = selectedScenarios
                }
            default:
                preconditionFailure("Wrong segue key")
            }
        case "addNums"?:
            let controller = segue.destination as! AddNumsViewController
            //Updates dictionary, so it holds only selectedPlayers
            updateDictionary()
            controller.availablePlayers = selectedPlayers
            controller.segueKey = addNumsSegueKey
            controller.game = selectedGame!
            switch addNumsSegueKey {
            case "Points"?:
                controller.playersPoints = playersPoints
            case "Places"?:
                controller.playersPlaces = playersPlaces
            case "Extended Points"?:
                guard let sectionNames = selectedGame?.pointsExtendedNameArray else { return }
                controller.playersPoints = playersPoints
                controller.sectionNames = sectionNames
                if dictionary["Points"] == nil {
                    var pointsDict = [Player: [Int]]()
                    for player in selectedPlayers {
                        pointsDict[player] = [Int](repeatElement(-99, count: sectionNames.count))
                    }
                    dictionary["Points"] = pointsDict
                } else {
                    var pointsDict = dictionary["Points"] as! [Player: [Int]]
                    for player in selectedPlayers {
                        if pointsDict[player] == nil {
                            pointsDict[player] = [Int](repeatElement(-99, count: sectionNames.count))
                        }
                    }
                    dictionary["Points"] = pointsDict
                }
                controller.dictionary = dictionary["Points"] as? [Player: [Int]]
            default:
                preconditionFailure("Wronge addNumsSegueKey")
            }
        case "addInfo"?:
            let controller = segue.destination as! AdditionalInfoViewController
            controller.segueKey = addInfoSegueKey
            controller.game = selectedGame
            if addInfoSegueKey == "Classes" {
                controller.winners = winners
                controller.loosers = loosers
                controller.availablePlayers = selectedPlayers
                if let classesDict = dictionary["Classes"] as? [Player: String] {
                    controller.playersClasses = classesDict
                }
                if let classesArray = selectedGame?.classesArray {
                    controller.myPickerData = classesArray
                    if let evilClassesArray = selectedGame?.evilClassesArray, let goodClassesArray = selectedGame?.goodClassesArray {
                        //Only Avalon have implementation how to distinguish evil classes from good classes
                        if selectedGame?.name == "Avalon" {
                            controller.myPickerDataEvil = evilClassesArray
                            controller.myPickerDataGood = goodClassesArray
                        }
                    }
                }
            } else if addInfoSegueKey == "Other" {
                if let diseasesDictionary = dictionary["Diseases"] as? [String: String] {
                    controller.dictionary = diseasesDictionary
                }
            }
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
        
        var places = [Int]()
        var players = [Player]()
        var points = [Int]()
        
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
            places = assignPlayersPlaces(sortedPoints: points)
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
            if selectedPlayers.isEmpty {
                createFailureAlert(with: "Players field cannot be empty!")
                return
            }
            players = selectedPlayers
            
            for _ in players {
                if myView.winSwitch.isOn {
                    places.append(1)
                } else {
                    places.append(2)
                }
            }
        }
        
        if game.pointsExtendedNameArray != nil {
            guard let _ = dictionary["Points"] as? [Player: [Int]] else {
                createFailureAlert(with: "Assign points!")
                return
            }
        }
        
        if game.classesArray != nil {
            guard let playersClassesDict = dictionary["Classes"] as? [Player: String] else {
                createFailureAlert(with: "Assign classes!")
                return
            }
            if !areClassesAssigned(playersClasses: playersClassesDict) {
                createFailureAlert(with: "Assign classes!")
                return
            }
        }
        
        if game.difficultyNames != nil {
            guard let _ = dictionary["Difficulty"] as? String else {
                createFailureAlert(with: "Assign difficulty!")
                return
            }
        }
        
        if let roundsName = game.roundsLeftName {
            guard let _ = dictionary["Rounds left"] as? Int else {
                createFailureAlert(with: "How many \(roundsName.lowercased()) were left?")
                return
            }
        }
        
        if game.winSwitch != nil {
            dictionary["Win"] = myView.winSwitch.isOn
        }
        
        if let switchName = game.additionalSwitchName {
            dictionary[switchName] = myView.additionalSwitch.isOn
        }
        
        if let secondSwitchName = game.additionalSecondSwitchName {
            dictionary[secondSwitchName] = myView.additionalSecondSwitch.isOn
        }
        
        let match = Match(game: game, players: players, playersPoints: points, playersPlaces: places, dictionary: dictionary, date: date!, time: time, location: location)
        game.addMatch(match: match)
        //If image was changed from default, then setImage
        if imageView.image != UIImage(named: "camera") {
            imageStore.setImage(image: imageView.image!, forKey: match.imageKey)
        }
        createSuccessAlert(with: "Created \(game.name)")
        playerStore.allPlayers.sort()
        gameStore.allGames.sort()
        return
    }
    
    //MARK: - Custom functions
    
    //Removes players that were already choosen as winners/loosers from availablePlayers array
    func updateAvailablePlayers() {
        availablePlayers = playerStore.allPlayers
        if chooserSegueKey == "loosers" {
            for winner in winners {
                let index = availablePlayers.index(of: winner)
                availablePlayers.remove(at: index!)
            }
        } else if chooserSegueKey == "winners" {
            for looser in loosers {
                let index = availablePlayers.index(of: looser)
                availablePlayers.remove(at: index!)
            }
        }
    }
    
    //Updates playersPoints and playersPlaces dictionaries - sets playersPlaces and playersPoints to 0 for selectedPlayers
    //And deletes deselectedPlayers from dictionary
    func updateDictionary() {
        if addNumsSegueKey == "Points" {
            for player in selectedPlayers {
                if playersPoints[player] == nil {
                    playersPoints[player] = 0
                }
            }
            for player in deselectedPlayers {
                playersPoints[player] = nil
            }
        } else if addNumsSegueKey == "Places" {
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
            if addNumsSegueKey == "Points" || addNumsSegueKey == "Extended Points" {
                if let points = playersPoints[player] {
                     string.append("\(player.name): \(points)")
                }
            } else if addNumsSegueKey == "Places" {
                if let place = playersPlaces[player] {
                    if place == 0 {
                        string.append("\(player.name)")
                    } else {
                        string.append("\(place). \(player.name)")
                    }
                }
            }
        }
        myView.pointsTextView.text = string.joined(separator: "\n")
        myView.pointsExtendedTextView.text = string.joined(separator: "\n")
        myView.placesTextView.text = string.joined(separator: "\n")
        locationManager.locationToString(location: location, textView: myView.locationTextView)
        
        string.removeAll()
        if let scenariosArray = dictionary["Scenarios"] as? [String] {
            for scenario in scenariosArray {
                string.append(scenario)
            }
        }
        myView.scenariosTextView.text = string.joined(separator: "\n")
        
        string.removeAll()
        if let expansionsArray = dictionary["Expansions"] as? [String] {
            for expansion in expansionsArray {
                string.append(expansion)
            }
        }
        myView.expansionsTextView.text = string.joined(separator: "\n")
        
        string.removeAll()
        if let playerClassDict = dictionary["Classes"] as? [Player: String] {
            for (player, playerClass) in playerClassDict {
                string.append("\(player) - \(playerClass)")
            }
        }
        myView.classesTextView.text = string.joined(separator: "\n")
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
    func assignPlayersPlaces(sortedPoints: [Int]) -> [Int] {
        if sortedPoints.sorted(by: {$0 > $1}) != sortedPoints {
            preconditionFailure("Points not sorted when assigning places!")
        }
        
        var places = [Int].init(repeating: 0, count: sortedPoints.count)
        //Sets place of first player to 1
        places[0] = 1
        for i in 1..<sortedPoints.count {
            //If current and previous players have same amount of points, then
            //set place of current player to place of previous player.
            //points = [30, 27, 27, 25, 23, 21, 21] -> places = [1, 2, 2, 4, 5, 6, 6]
            if sortedPoints[i] == sortedPoints[i-1] {
                places[i] = places[i-1]
            } else {
                places[i] = i+1
            }
        }
        return places
    }
    
    //Sorts players according to playersPlaces dictionary
    func sortPlayersPlaces(players: inout [Player], placesDict: [Player: Int]) {
        players.sort { (p1, p2) -> Bool in
            if placesDict[p1]! == 0 {
                return false
            } else if placesDict[p2]! == 0 {
                return true
            } else if placesDict[p1]! < placesDict[p2]! {
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
    
    func areClassesAssigned(playersClasses: [Player: String]) -> Bool {
        if winners.isEmpty && loosers.isEmpty {
            for player in selectedPlayers {
                if playersClasses[player] == nil {
                    return false
                }
            }
        } else {
            for player in winners + loosers {
                if playersClasses[player] == nil {
                    return false
                }
            }
        }
        return true
    }
    
    //MARK: - Alerts
    
    //Success alert with given string that disappears after 1 second and pops to previous controller
    func createSuccessAlert(with string: String) {
        let alert = Constants.Functions.createAlert(title: "Success!", message: string)
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
        let alert = Constants.Functions.createAlert(title: "Failure!", message: string)
        alert.addAction(UIAlertAction(title: "Ok!", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Picker
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return pickerDataNumbers.count
        } else if pickerView.tag == 2 {
            return pickerDifficultyNames.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        if picker.tag == 1 {
            return String(pickerDataNumbers[row])
        } else if picker.tag == 2 {
            return pickerDifficultyNames[row]
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        //When selected, then update dictionary and textView
        if pickerView.tag == 1 {
            dictionary["Rounds left"] = pickerDataNumbers[row]
            myView.roundsLeftTextView.text = String(pickerDataNumbers[row])
        } else if pickerView.tag == 2 {
            dictionary["Difficulty"] = pickerDifficultyNames[row]
            myView.difficultyTextView.text = pickerDifficultyNames[row]
        }
    }
    
    //MARK: - Pickers toolbar
    
    //PickerView Toolbar button functions
    
    //Checks which picker mode is chosen and accordingly updates correct views and variables
    //And resigns first responder
    @objc func doneDatePicker() {
        if datePicker.datePickerMode == .countDownTimer {
            time = datePicker.countDownDuration
            myView.timeTextView.text = time?.toString()
            myView.timeTextView.resignFirstResponder()
        } else if datePicker.datePickerMode == .dateAndTime {
            date = datePicker.date
            myView.dateTextView.text = date?.toStringWithHour()
            myView.dateTextView.resignFirstResponder()
        }
    }
    
    @objc func donePicker() {
        if picker.tag == 1 {
            myView.roundsLeftTextView.resignFirstResponder()
        } else if picker.tag == 2 {
            myView.difficultyTextView.resignFirstResponder()
        }
    }
    
    //If cancel picker, then accordingly reverts correct views to default values
    //And resigns first responder
    @objc func cancelDatePicker() {
        if datePicker.datePickerMode == .countDownTimer {
            time = nil
            myView.timeTextView.text = ""
            myView.timeTextView.resignFirstResponder()
        } else if datePicker.datePickerMode == .dateAndTime {
            date = Date()
            myView.dateTextView.text = date?.toStringWithHour()
            myView.dateTextView.resignFirstResponder()
        }
        datePicker.resignFirstResponder()
    }
    
    @objc func cancelPicker() {
        if picker.tag == 1 {
            myView.roundsLeftTextView.resignFirstResponder()
            myView.roundsLeftTextView.text = ""
            dictionary["Rounds left"] = nil
        } else if picker.tag == 2 {
            myView.difficultyTextView.resignFirstResponder()
            myView.difficultyTextView.text = ""
            dictionary["Difficulty"] = nil
        }
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
