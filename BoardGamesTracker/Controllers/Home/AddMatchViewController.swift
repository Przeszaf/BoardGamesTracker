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
    let pickerPandemicDifficulty = ["Easy (4 Epidemy cards)", "Medium (5 Epidemy cards)", "Hard (6 Epidemy cards)"]
    
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
        
        myView.gameTextView.delegate = self
        myView.playersTextView.delegate = self
        myView.winnersTextView.delegate = self
        myView.loosersTextView.delegate = self
        myView.pointsTextView.delegate = self
        myView.dateTextView.delegate = self
        myView.timeTextView.delegate = self
        myView.dictionaryTextView.delegate = self
        myView.additionalTextView.delegate = self
        myView.additionalSecondTextView.delegate = self
        myView.additionalThirdTextView.delegate = self
        
        
        //At the beginning show only stack views below
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
        
        
        
        if let game = selectedGame {
            myView.dateStackView.isHidden = false
            myView.timeStackView.isHidden = false
            myView.locationStackView.isHidden = false
            imageView.isHidden = false
            myView.dateTextView.text = date?.toStringWithHour()
//            myView.timeTextView.text = time?.toString()
            if game.type == .TeamWithPlaces {
                myView.winnersStackView.isHidden = false
                myView.loosersStackView.isHidden = false
            } else if game.type == .SoloWithPoints {
                myView.playersStackView.isHidden = false
                myView.pointsStackView.isHidden = false
                myView.pointsLabel.text = "Points"
                addNumsSegueKey = "Points"
            } else if game.type == .SoloWithPlaces {
                myView.playersStackView.isHidden = false
                myView.pointsLabel.text = "Places"
                addNumsSegueKey = "Places"
                myView.pointsStackView.isHidden = false
            } else if game.type == .Cooperation {
                myView.playersStackView.isHidden = false
                myView.switchStackView.isHidden = false
                myView.switchLabel.text = "Did you win?"
            }
            if let customGame = game as? CustomGame {
                if customGame.name == "Avalon" {
                    myView.dictionaryStackView.isHidden = false
                    myView.dictionaryLabel.text = "Classes"
                    
                    myView.switchTwoStackView.isHidden = false
                    myView.switchTwoLabel.text = "Playing with lady of the Lake?"
                    
                    if winners.count < loosers.count {
                        myView.switchStackView.isHidden = false
                        myView.switchLabel.text = "Merlin killed by Assassin?"
                    }
                }
                if customGame.name == "Pandemic" {
                    myView.dictionaryStackView.isHidden = false
                    myView.dictionaryLabel.text = "Classes"
                    
                    myView.additionalStackView.isHidden = false
                    myView.additionalLabel.text = "Diseases"
                    
                    myView.additionalSecondStackView.isHidden = false
                    myView.additionalSecondLabel.text = "Cards left?"
                    myView.additionalSecondTextView.inputView = picker
                    myView.additionalSecondTextView.inputAccessoryView = pickerToolbar
                    
                    myView.additionalThirdStackView.isHidden = false
                    myView.additionalThirdLabel.text = "Difficulty"
                    myView.additionalThirdTextView.inputView = picker
                    myView.additionalThirdTextView.inputAccessoryView = pickerToolbar
                } else if customGame.name == "Carcassonne" {
                    myView.additionalTextView.isHidden = false
                    myView.additionalLabel.text = "Expansions"
                } else if customGame.name == "Codenames" {
                    myView.switchStackView.isHidden = false
                    myView.switchLabel.text = "Killed by Assassin?"
                    
                    myView.additionalSecondStackView.isHidden = false
                    myView.additionalSecondLabel.text = "Cards left?"
                    myView.additionalSecondTextView.inputView = picker
                    myView.additionalSecondTextView.inputAccessoryView = pickerToolbar
                } else if customGame.name == "7 Wonders" {
                    myView.dictionaryStackView.isHidden = false
                    myView.dictionaryLabel.text = "Classes"
                    
                    myView.additionalStackView.isHidden = false
                    myView.additionalLabel.text = "Expansions"
                } else if customGame.name == "Robinson Crusoe" {
                    myView.dictionaryStackView.isHidden = false
                    myView.dictionaryLabel.text = "Classes"
                    
                    myView.additionalStackView.isHidden = false
                    myView.additionalLabel.text = "Scenario"
                    
                    myView.additionalSecondStackView.isHidden = false
                    myView.additionalSecondLabel.text = "Days left?"
                    myView.additionalSecondTextView.inputView = picker
                    myView.additionalSecondTextView.inputAccessoryView = pickerToolbar
                    
                    myView.additionalThirdStackView.isHidden = false
                    myView.additionalThirdLabel.text = "Points"
                    myView.additionalThirdTextView.inputView = picker
                    myView.additionalThirdTextView.inputAccessoryView = pickerToolbar
                    
                    myView.switchStackView.isHidden = false
                    myView.switchLabel.text = "Playing with Friday?"
                    
                    myView.switchTwoStackView.isHidden = false
                    myView.switchTwoLabel.text = "Playing with dog?"
                    
                    myView.pointsStackView.isHidden = true
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
        print(dateSinceSegue.timeIntervalSinceNow)
        if Float(dateSinceSegue.timeIntervalSinceNow) < -0.1 {
            if textView == myView.pointsTextView && selectedGame?.name != "7 Wonders" {
                performSegue(withIdentifier: "addNums", sender: self)
            } else if textView == myView.playersTextView || textView == myView.loosersTextView || textView == myView.winnersTextView {
                print("Performing segue")
                performSegue(withIdentifier: "chooser", sender: self)
            } else if textView == myView.gameTextView {
                performSegue(withIdentifier: "chooseGame", sender: self)
            } else if textView == myView.dictionaryTextView && (selectedGame?.name == "Avalon" || selectedGame?.name == "Pandemic" || selectedGame?.name == "7 Wonders" || selectedGame?.name == "Robinson Crusoe") {
                addInfoSegueKey = "Classes"
                performSegue(withIdentifier: "addInfo", sender: self)
            } else if textView == myView.additionalTextView && selectedGame!.name == "Pandemic" {
                addInfoSegueKey = "Diseases"
                performSegue(withIdentifier: "addInfo", sender: self)
            } else if textView == myView.additionalTextView && selectedGame?.name == "Carcassonne" {
                chooserSegueKey = "Carcassonne Expansions"
                performSegue(withIdentifier: "chooser", sender: self)
            } else if textView == myView.additionalTextView && selectedGame?.name == "7 Wonders" {
                chooserSegueKey = "7 Wonders Expansions"
                performSegue(withIdentifier: "chooser", sender: self)
            } else if textView == myView.pointsTextView && selectedGame?.name == "7 Wonders" {
                addNumsSegueKey = "7 Wonders"
                performSegue(withIdentifier: "addNums", sender: self)
            } else if textView == myView.additionalTextView && selectedGame?.name == "Robinson Crusoe" {
                chooserSegueKey = "Robinson Crusoe Scenarios"
                performSegue(withIdentifier: "chooser", sender: self)
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
        
        //Taking care of custom games
        if let customGame = selectedGame as? CustomGame {
            if customGame.name == "Pandemic" {
                if textView == myView.additionalSecondTextView {
                    //Picker tag is used to load correct data
                    picker.tag = 1
                    picker.reloadAllComponents()
                    //If it is first click, then assign first option to textView
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
                } else if textView == myView.additionalThirdTextView {
                    picker.tag = 2
                    picker.reloadAllComponents()
                    if textView.text == "" {
                        textView.text = pickerPandemicDifficulty[0]
                        picker.selectRow(0, inComponent: 0, animated: false)
                    } else {
                        let index = pickerPandemicDifficulty.index(of: textView.text)
                        picker.selectRow(index!, inComponent: 0, animated: false)
                    }
                    return true
                }
            } else if customGame.name == "Codenames" {
                if textView == myView.additionalSecondTextView {
                    //Picker tag is used to load correct data
                    picker.tag = 1
                    picker.reloadAllComponents()
                    //If it is first click, then assign first option to textView
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
                }
            } else if customGame.name == "Robinson Crusoe" {
                if textView == myView.additionalSecondTextView {
                    picker.tag = 1
                    picker.reloadAllComponents()
                    if textView.text == "" {
                        textView.text = String(pickerDataNumbers[0])
                        picker.selectRow(0, inComponent: 0, animated: false)
                    } else {
                        guard let num = Int(textView.text) else { return false }
                        let index = pickerDataNumbers.index(of: num)
                        picker.selectRow(index!, inComponent: 0, animated: false)
                    }
                    return true
                } else if textView == myView.additionalThirdTextView {
                    picker.tag = 2
                    picker.reloadAllComponents()
                    if textView.text == "" {
                        textView.text = String(pickerDataNumbers[0])
                        picker.selectRow(0, inComponent: 0, animated: false)
                    } else {
                        guard let num = Int(textView.text) else { return false }
                        let index = pickerDataNumbers.index(of: num)
                        picker.selectRow(index!, inComponent: 0, animated: false)
                    }
                    return true
                }
            }
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
            case _ where chooserSegueKey!.contains("Expansion"):
                if let expansionsArray = dictionary["Expansions"] as? [String] {
                    controller.selectedExpansions = expansionsArray
                }
            case _ where chooserSegueKey!.contains("Scenario"):
                if let scenariosArray = dictionary["Scenarios"] as? [String] {
                    controller.selectedScenarios = scenariosArray
                }
            default:
                preconditionFailure("Wrong segue key")
            }
        case "addNums"?:
            let controller = segue.destination as! AddNumsViewController
            //Updates dictionary, so it holds only selectedPlayers
            updateDictionary()
            controller.availablePlayers = selectedPlayers
            switch addNumsSegueKey {
            case "Points"?:
                controller.playersPoints = playersPoints
                controller.segueKey = addNumsSegueKey
            case "Places"?:
                controller.segueKey = addNumsSegueKey
                controller.playersPlaces = playersPlaces
            case "7 Wonders"?:
                controller.playersPoints = playersPoints
                controller.segueKey = addNumsSegueKey
                if dictionary["Points"] == nil {
                    var pointsDict = [Player: [Int]]()
                    for player in selectedPlayers {
                        pointsDict[player] = [Int](repeatElement(-99, count: 8))
                    }
                    dictionary["Points"] = pointsDict
                } else {
                    var pointsDict = dictionary["Points"] as! [Player: [Int]]
                    for player in selectedPlayers {
                        if pointsDict[player] == nil {
                            pointsDict[player] = [Int](repeatElement(-99, count: 8))
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
                controller.playersClasses = playersClasses
            } else if addInfoSegueKey == "Diseases" {
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
                if areClassesAssigned() {
                    match = CustomMatch(game: game, players: players, playersPoints: nil, playersPlaces: places, date: date!, time: time, location: location, dictionary: dictionary, playersClasses: playersClasses)
                } else {
                    createFailureAlert(with: "Assign classes!")
                    return
                }
            }
            
            else if customGame.name == "Pandemic" {
                if myView.additionalSecondTextView.text == "" {
                    createFailureAlert(with: "How many cards were left?")
                    return
                } else if myView.additionalThirdTextView.text == "" {
                    createFailureAlert(with: "What difficulty level did you play?")
                    return
                }
                dictionary["Cards left"] = Int(myView.additionalSecondTextView.text)
                dictionary["Difficulty"] = myView.additionalThirdTextView.text
                
                guard let diseasesDictionary = dictionary["Diseases"] as? [String: String] else {
                    createFailureAlert(with: "Are all diseases cured?")
                    return
                }
                for diseaseName in PandemicDiseasesName.array {
                    if diseasesDictionary[diseaseName] == nil {
                        createFailureAlert(with: "Not all diseases are assigned!")
                        return
                    }
                }
                if areClassesAssigned() {
                    print(playersClasses)
                    match = CustomMatch(game: game, players: players, playersPoints: nil, playersPlaces: places, date: date!, time: time, location: location, dictionary: dictionary, playersClasses: playersClasses)
                } else {
                    createFailureAlert(with: "Assign classes!")
                    return
                }
            }
            
            else if customGame.name == "Carcassonne" {
                match = CustomMatch(game: game, players: players, playersPoints: points, playersPlaces: places, date: date!, time: time, location: location, dictionary: dictionary, playersClasses: nil)
            }
            else if customGame.name == "Codenames" {
                if myView.additionalSecondTextView.text == "" {
                    createFailureAlert(with: "How many cards were left?")
                    return
                }
                dictionary["Assassin?"] = myView.mySwitch.isOn
                dictionary["Cards left"] = Int(myView.additionalSecondTextView.text)
                match = CustomMatch(game: game, players: players, playersPoints: nil, playersPlaces: places, date: date!, time: time, location: location, dictionary: dictionary, playersClasses: nil)
            } else if customGame.name == "7 Wonders" {
                if areClassesAssigned() {
                    print(playersClasses)
                    match = CustomMatch(game: game, players: players, playersPoints: points, playersPlaces: places, date: date!, time: time, location: location, dictionary: dictionary, playersClasses: playersClasses)
                } else {
                    createFailureAlert(with: "Assign classes!")
                    return
                }
            } else if customGame.name == "Robinson Crusoe" {
                if myView.additionalSecondTextView.text == "" {
                    createFailureAlert(with: "How many days were left?")
                    return
                }
                if dictionary["Scenarios"] == nil {
                    createFailureAlert(with: "Which scenario did you play?")
                    return
                }
                if areClassesAssigned() {
                    print(playersClasses)
                    dictionary["Dog?"] = myView.mySwitch.isOn
                    dictionary["Friday?"] = myView.mySwitchTwo.isOn
                    dictionary["Days left"] = Int(myView.additionalSecondTextView.text)
                    dictionary["Points"] = Int(myView.additionalThirdTextView.text)
                    match = CustomMatch(game: game, players: players, playersPoints: nil, playersPlaces: places, date: date!, time: time, location: location, dictionary: dictionary, playersClasses: playersClasses)
                } else {
                    createFailureAlert(with: "Assign classes!")
                    return
                }
            }
            //Else create normal Match
        } else if game.type == .TeamWithPlaces || game.type == .SoloWithPlaces || game.type == .Cooperation {
            match = Match(game: game, players: players, playersPoints: nil, playersPlaces: places, date: self.date!, time: self.time, location: self.location)
        } else if game.type == .SoloWithPoints {
            match = Match(game: game, players: players, playersPoints: points, playersPlaces: places, date: self.date!, time: self.time, location: self.location)
        }
        game.addMatch(match: match!)
        gameStore.allGames.sort()
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
            if addNumsSegueKey == "Points" {
                string.append("\(player.name): \(playersPoints[player] ?? 0)")
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
        myView.pointsTextView.text = string.joined(separator: ", ")
        locationManager.locationToString(location: location, textView: myView.locationTextView)
        
        //Creates strings for custom games
        string.removeAll()
        if let customGame = selectedGame as? CustomGame {
            if customGame.name == "Avalon" || customGame.name == "Pandemic" || customGame.name == "7 Wonders" || customGame.name == "Robinson Crusoe" {
                let classesDictionary = playersClasses
                if winners.isEmpty && loosers.isEmpty {
                    for player in selectedPlayers {
                        string.append("\(player) - \(classesDictionary[player] ?? "none")")
                    }
                } else {
                    for player in winners + loosers {
                        string.append("\(player) - \(classesDictionary[player] ?? "none")")
                    }
                }
                myView.dictionaryTextView.text = string.joined(separator: "\n")
                string.removeAll()
            }
            
            
            if customGame.name == "Pandemic" {
                if let diseasesDictionary = dictionary["Diseases"] as? [String: String] {
                    for diseaseName in PandemicDiseasesName.array {
                        string.append("\(diseaseName) - \(diseasesDictionary[diseaseName] ?? "N/A")")
                    }
                    myView.additionalTextView.text = string.joined(separator: "\n")
                    string.removeAll()
                }
            }
            if customGame.name == "Carcassonne" || customGame.name == "7 Wonders"{
                if let expansionsArray = dictionary["Expansions"] as? [String] {
                    for expansion in expansionsArray {
                        string.append(expansion)
                    }
                }
                myView.additionalTextView.text = string.joined(separator: "\n")
                string.removeAll()
            }
            if customGame.name == "Robinson Crusoe" {
                if let scenariosArray = dictionary["Scenarios"] as? [String] {
                    for scenario in scenariosArray {
                        string.append(scenario)
                    }
                }
                myView.additionalTextView.text = string.joined(separator: "\n")
            }
        }
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
    
    func areClassesAssigned() -> Bool {
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
        guard let customGame = selectedGame as? CustomGame else { return 0 }
        if pickerView.tag == 1 && (customGame.name == "Pandemic" || customGame.name == "Codenames") {
            return pickerDataNumbers.count
        } else if pickerView.tag == 2 && customGame.name == "Pandemic" {
            return pickerPandemicDifficulty.count
        } else if pickerView.tag == 1 && customGame.name == "Robinson Crusoe" {
            return 8
        } else if pickerView.tag == 2 && customGame.name == "Robinson Crusoe" {
            return pickerDataNumbers.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        guard let customGame = selectedGame as? CustomGame else { return "" }
        if customGame.name == "Pandemic" {
            if picker.tag == 1 {
                return String(pickerDataNumbers[row])
            } else if picker.tag == 2 {
                return pickerPandemicDifficulty[row]
            }
        } else if customGame.name == "Codenames" || customGame.name == "Robinson Crusoe" {
            return String(pickerDataNumbers[row])
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        //When selected, then update dictionary and textView
        if let customGame = selectedGame as? CustomGame {
            if customGame.name == "Pandemic" {
                if pickerView.tag == 1 {
                    dictionary["Cards left"] = pickerDataNumbers[row]
                    myView.additionalSecondTextView.text = String(pickerDataNumbers[row])
                } else if pickerView.tag == 2 {
                    dictionary["Difficulty"] = pickerPandemicDifficulty[row]
                    myView.additionalThirdTextView.text = pickerPandemicDifficulty[row]
                }
            } else if customGame.name == "Codenames" {
                dictionary["Cards left"] = pickerDataNumbers[row]
                myView.additionalSecondTextView.text = String(pickerDataNumbers[row])
            } else if customGame.name == "Robinson Crusoe" {
                if pickerView.tag == 1 {
                    dictionary["Days left"] = pickerDataNumbers[row]
                    myView.additionalSecondTextView.text = String(pickerDataNumbers[row])
                } else if pickerView.tag == 2 {
                    dictionary["Points"] = pickerDataNumbers[row]
                    myView.additionalThirdTextView.text = String(pickerDataNumbers[row])
                }
            }
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
            myView.additionalSecondTextView.resignFirstResponder()
        } else if picker.tag == 2 {
            myView.additionalThirdTextView.resignFirstResponder()
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
        if selectedGame?.name == "Pandemic" {
            if picker.tag == 1 {
                myView.additionalSecondTextView.resignFirstResponder()
                myView.additionalSecondTextView.text = ""
                dictionary["Cards left"] = nil
            } else if picker.tag == 2 {
                myView.additionalThirdTextView.resignFirstResponder()
                myView.additionalThirdTextView.text = ""
                dictionary["Difficulty"] = nil
            }
        } else if selectedGame?.name == "Codenames" {
            myView.additionalSecondTextView.resignFirstResponder()
            myView.additionalSecondTextView.text = ""
            dictionary["Cards left"] = nil
        } else if selectedGame?.name == "Robinson Crusoe" {
            if picker.tag == 1 {
                myView.additionalSecondTextView.resignFirstResponder()
                myView.additionalSecondTextView.text = ""
                dictionary["Days left"] = nil
            } else if picker.tag == 2 {
                myView.additionalThirdTextView.resignFirstResponder()
                myView.additionalThirdTextView.text = ""
                dictionary["Points"] = nil
            }
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
