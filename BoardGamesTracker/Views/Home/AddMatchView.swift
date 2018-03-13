//
//  AddMatchView.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 06/02/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//

import UIKit

class AddMatchView: UIView {
    
    //MARK: - All Stack views needed
    var verticalStackView = UIStackView()
    var gameStackView = UIStackView()
    var playersStackView = UIStackView()
    var winnersStackView = UIStackView()
    var loosersStackView = UIStackView()
    var pointsStackView = UIStackView()
    var placesStackView = UIStackView()
    var pointsExtendedStackView = UIStackView()
    var professionsStackView = UIStackView()
    var expansionsStackView = UIStackView()
    var scenariosStackView = UIStackView()
    var difficultyStackView = UIStackView()
    var winSwitchStackView = UIStackView()
    var roundsLeftStackView = UIStackView()
    var additionalSwitchStackView = UIStackView()
    var additionalStackView = UIStackView()
    var additionalSecondStackView = UIStackView()
    var additionalThirdStackView = UIStackView()
    var dateStackView = UIStackView()
    var timeStackView = UIStackView()
    var locationStackView = UIStackView()
    var imageViewStackView = UIStackView()
    
    
    //MARK: - All labels
    var gameLabel = UILabel()
    var playersLabel = UILabel()
    var winnersLabel = UILabel()
    var loosersLabel = UILabel()
    var pointsLabel = UILabel()
    var placesLabel = UILabel()
    var pointsExtendedLabel = UILabel()
    var professionsLabel = UILabel()
    var expansionsLabel = UILabel()
    var scenariosLabel = UILabel()
    var difficultyLabel = UILabel()
    var winSwitchLabel = UILabel()
    var roundsLeftLabel = UILabel()
    var additionalSwitchLabel = UILabel()
    var additionalLabel = UILabel()
    var additionalSecondLabel = UILabel()
    var additionalThirdLabel = UILabel()
    var dateLabel = UILabel()
    var timeLabel = UILabel()
    var locationLabel = UILabel()
    
    //MARK: - All text views and switches
    var gameTextView = AddMatchTextView()
    var playersTextView = AddMatchTextView()
    var winnersTextView = AddMatchTextView()
    var loosersTextView = AddMatchTextView()
    var pointsTextView = AddMatchTextView()
    var placesTextView = AddMatchTextView()
    var pointsExtendedTextView = AddMatchTextView()
    var professionsTextView = AddMatchTextView()
    var expansionsTextView = AddMatchTextView()
    var scenariosTextView = AddMatchTextView()
    var difficultyTextView = AddMatchTextView()
    var winSwitch = UISwitch()
    var roundsLeftTextView = AddMatchTextView()
    var additionalSwitch = UISwitch()
    var additionalTextView = AddMatchTextView()
    var additionalSecondTextView = AddMatchTextView()
    var additionalThirdTextView = AddMatchTextView()
    var dateTextView = AddMatchTextView()
    var timeTextView = AddMatchTextView()
    var locationTextView = AddMatchTextView()
    
    var imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        verticalStackView.axis = .vertical
        addSubviews()
        setTranslatesAutoresizingMaskIntoConstraintToFalse()
        hideAllStackViews()
        winSwitch.tintColor = UIColor.white
        winSwitch.backgroundColor = UIColor.white
        winSwitch.layer.cornerRadius = 16
        
        additionalSwitch.tintColor = UIColor.white
        additionalSwitch.backgroundColor = UIColor.white
        additionalSwitch.layer.cornerRadius = 16
        
        gameLabel.text = "Game"
        playersLabel.text = "Players"
        winnersLabel.text = "Winners"
        loosersLabel.text = "Loosers"
        pointsLabel.text = "Points"
        placesLabel.text = "Places"
        pointsExtendedLabel.text = "Points"
        professionsLabel.text = "Classes"
        expansionsLabel.text = "Expansions"
        scenariosLabel.text = "Scenarios"
        difficultyLabel.text = "Difficulty"
        winSwitchLabel.text = "Did you win?"
        roundsLeftLabel.text = "XXX left?"
        additionalSwitchLabel.text = "Additional switch?"
        additionalLabel.text = "Additional"
        additionalSecondLabel.text = "Additional2"
        additionalThirdLabel.text = "Additional3"
        dateLabel.text = "Date"
        timeLabel.text = "Time"
        locationLabel.text = "Location"
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setTranslatesAutoresizingMaskIntoConstraintToFalse()
        
        verticalStackView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        verticalStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        verticalStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        verticalStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        verticalStackView.spacing = 8
        
        
        
        //All labes have the same leading and trailing anchors
        gameLabel.leadingAnchor.constraint(equalTo: playersLabel.leadingAnchor).isActive = true
        playersLabel.leadingAnchor.constraint(equalTo: pointsLabel.leadingAnchor).isActive = true
        pointsLabel.leadingAnchor.constraint(equalTo: winnersLabel.leadingAnchor).isActive = true
        winnersLabel.leadingAnchor.constraint(equalTo: loosersLabel.leadingAnchor).isActive = true
        loosersLabel.leadingAnchor.constraint(equalTo: pointsLabel.leadingAnchor).isActive = true
        pointsLabel.leadingAnchor.constraint(equalTo: placesLabel.leadingAnchor).isActive = true
        placesLabel.leadingAnchor.constraint(equalTo: pointsExtendedLabel.leadingAnchor).isActive = true
        pointsExtendedLabel.leadingAnchor.constraint(equalTo: professionsLabel.leadingAnchor).isActive = true
        professionsLabel.leadingAnchor.constraint(equalTo: expansionsLabel.leadingAnchor).isActive = true
        expansionsLabel.leadingAnchor.constraint(equalTo: scenariosLabel.leadingAnchor).isActive = true
        scenariosLabel.leadingAnchor.constraint(equalTo: difficultyLabel.leadingAnchor).isActive = true
        difficultyLabel.leadingAnchor.constraint(equalTo: winSwitchLabel.leadingAnchor).isActive = true
        winSwitchLabel.leadingAnchor.constraint(equalTo: roundsLeftLabel.leadingAnchor).isActive = true
        roundsLeftLabel.leadingAnchor.constraint(equalTo: additionalSwitchLabel.leadingAnchor).isActive = true
        additionalSwitchLabel.leadingAnchor.constraint(equalTo: additionalLabel.leadingAnchor).isActive = true
        additionalLabel.leadingAnchor.constraint(equalTo: additionalSecondLabel.leadingAnchor).isActive = true
        additionalSecondLabel.leadingAnchor.constraint(equalTo: additionalThirdLabel.leadingAnchor).isActive = true
        additionalThirdLabel.leadingAnchor.constraint(equalTo: dateLabel.leadingAnchor).isActive = true
        dateLabel.leadingAnchor.constraint(equalTo: locationLabel.leadingAnchor).isActive = true
        
        gameLabel.trailingAnchor.constraint(equalTo: playersLabel.trailingAnchor).isActive = true
        playersLabel.trailingAnchor.constraint(equalTo: pointsLabel.trailingAnchor).isActive = true
        pointsLabel.trailingAnchor.constraint(equalTo: winnersLabel.trailingAnchor).isActive = true
        winnersLabel.trailingAnchor.constraint(equalTo: loosersLabel.trailingAnchor).isActive = true
        loosersLabel.trailingAnchor.constraint(equalTo: pointsLabel.trailingAnchor).isActive = true
        pointsLabel.trailingAnchor.constraint(equalTo: placesLabel.trailingAnchor).isActive = true
        placesLabel.trailingAnchor.constraint(equalTo: pointsExtendedLabel.trailingAnchor).isActive = true
        pointsExtendedLabel.trailingAnchor.constraint(equalTo: professionsLabel.trailingAnchor).isActive = true
        professionsLabel.trailingAnchor.constraint(equalTo: expansionsLabel.trailingAnchor).isActive = true
        expansionsLabel.trailingAnchor.constraint(equalTo: scenariosLabel.trailingAnchor).isActive = true
        scenariosLabel.trailingAnchor.constraint(equalTo: difficultyLabel.trailingAnchor).isActive = true
        difficultyLabel.trailingAnchor.constraint(equalTo: roundsLeftLabel.trailingAnchor).isActive = true
        roundsLeftLabel.trailingAnchor.constraint(equalTo: additionalLabel.trailingAnchor).isActive = true
        additionalLabel.trailingAnchor.constraint(equalTo: additionalSecondLabel.trailingAnchor).isActive = true
        additionalSecondLabel.trailingAnchor.constraint(equalTo: additionalThirdLabel.trailingAnchor).isActive = true
        additionalThirdLabel.trailingAnchor.constraint(equalTo: dateLabel.trailingAnchor).isActive = true
        dateLabel.trailingAnchor.constraint(equalTo: locationLabel.trailingAnchor).isActive = true
        
        
        winSwitch.widthAnchor.constraint(equalToConstant: 49).isActive = true
        winSwitch.leadingAnchor.constraint(equalTo: additionalSwitch.leadingAnchor).isActive = true

        
        winSwitchLabel.trailingAnchor.constraint(equalTo: roundsLeftLabel.trailingAnchor).isActive = false
        additionalSwitchLabel.trailingAnchor.constraint(equalTo: additionalLabel.trailingAnchor).isActive = false
        
        winSwitchStackView.distribution = .fillProportionally
        additionalSwitchStackView.distribution = .fillProportionally
        

        
        
        
        locationTextView.isEditable = false
        
        
        //Width of labels is set to width of longest string in labels + 8
        var width = CGFloat(50)
        
        let labels = getVisibleLabels()
        
        for label in labels {
            guard let labelWidth = label.text?.width(withConstrainedHeight: 100, font: UIFont.systemFont(ofSize: 17)) else { return }
            if labelWidth > width {
                if label != winSwitchLabel && label != additionalSwitchLabel {
                    width = labelWidth
                }
            }
        }
        
        gameLabel.widthAnchor.constraint(equalToConstant: width + 8).isActive = true
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK: - Functions
    
    func setTranslatesAutoresizingMaskIntoConstraintToFalse() {
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        gameStackView.translatesAutoresizingMaskIntoConstraints = false
        gameLabel.translatesAutoresizingMaskIntoConstraints = false
        gameTextView.translatesAutoresizingMaskIntoConstraints = false
        
        playersStackView.translatesAutoresizingMaskIntoConstraints = false
        playersLabel.translatesAutoresizingMaskIntoConstraints = false
        playersTextView.translatesAutoresizingMaskIntoConstraints = false
        
        winnersStackView.translatesAutoresizingMaskIntoConstraints = false
        winnersLabel.translatesAutoresizingMaskIntoConstraints = false
        winnersTextView.translatesAutoresizingMaskIntoConstraints = false
        
        loosersStackView.translatesAutoresizingMaskIntoConstraints = false
        loosersLabel.translatesAutoresizingMaskIntoConstraints = false
        loosersTextView.translatesAutoresizingMaskIntoConstraints = false
        
        pointsStackView.translatesAutoresizingMaskIntoConstraints = false
        pointsLabel.translatesAutoresizingMaskIntoConstraints = false
        pointsTextView.translatesAutoresizingMaskIntoConstraints = false
        
        placesStackView.translatesAutoresizingMaskIntoConstraints = false
        placesLabel.translatesAutoresizingMaskIntoConstraints = false
        placesTextView.translatesAutoresizingMaskIntoConstraints = false
        
        pointsExtendedStackView.translatesAutoresizingMaskIntoConstraints = false
        pointsExtendedLabel.translatesAutoresizingMaskIntoConstraints = false
        pointsExtendedTextView.translatesAutoresizingMaskIntoConstraints = false
        
        professionsStackView.translatesAutoresizingMaskIntoConstraints = false
        professionsLabel.translatesAutoresizingMaskIntoConstraints = false
        professionsTextView.translatesAutoresizingMaskIntoConstraints = false
        
        expansionsStackView.translatesAutoresizingMaskIntoConstraints = false
        expansionsLabel.translatesAutoresizingMaskIntoConstraints = false
        expansionsTextView.translatesAutoresizingMaskIntoConstraints = false
        
        scenariosStackView.translatesAutoresizingMaskIntoConstraints = false
        scenariosLabel.translatesAutoresizingMaskIntoConstraints = false
        scenariosTextView.translatesAutoresizingMaskIntoConstraints = false

        winSwitchStackView.translatesAutoresizingMaskIntoConstraints = false
        winSwitchLabel.translatesAutoresizingMaskIntoConstraints = false
        winSwitch.translatesAutoresizingMaskIntoConstraints = false
        
        roundsLeftStackView.translatesAutoresizingMaskIntoConstraints = false
        roundsLeftLabel.translatesAutoresizingMaskIntoConstraints = false
        roundsLeftTextView.translatesAutoresizingMaskIntoConstraints = false
        
        additionalSwitchStackView.translatesAutoresizingMaskIntoConstraints = false
        additionalSwitchLabel.translatesAutoresizingMaskIntoConstraints = false
        additionalSwitch.translatesAutoresizingMaskIntoConstraints = false
        
        additionalStackView.translatesAutoresizingMaskIntoConstraints = false
        additionalLabel.translatesAutoresizingMaskIntoConstraints = false
        additionalTextView.translatesAutoresizingMaskIntoConstraints = false
        
        additionalSecondStackView.translatesAutoresizingMaskIntoConstraints = false
        additionalSecondLabel.translatesAutoresizingMaskIntoConstraints = false
        additionalSecondTextView.translatesAutoresizingMaskIntoConstraints = false
        
        additionalThirdStackView.translatesAutoresizingMaskIntoConstraints = false
        additionalThirdLabel.translatesAutoresizingMaskIntoConstraints = false
        additionalThirdTextView.translatesAutoresizingMaskIntoConstraints = false
        
        dateStackView.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateTextView.translatesAutoresizingMaskIntoConstraints = false
        
        timeStackView.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeTextView.translatesAutoresizingMaskIntoConstraints = false
        
        locationStackView.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        locationTextView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    func addSubviews() {
        addSubview(verticalStackView)
        verticalStackView.addArrangedSubview(gameStackView)
        gameStackView.addArrangedSubview(gameLabel)
        gameStackView.addArrangedSubview(gameTextView)
        
        verticalStackView.addArrangedSubview(playersStackView)
        playersStackView.addArrangedSubview(playersLabel)
        playersStackView.addArrangedSubview(playersTextView)
        
        verticalStackView.addArrangedSubview(winnersStackView)
        winnersStackView.addArrangedSubview(winnersLabel)
        winnersStackView.addArrangedSubview(winnersTextView)
        
        verticalStackView.addArrangedSubview(loosersStackView)
        loosersStackView.addArrangedSubview(loosersLabel)
        loosersStackView.addArrangedSubview(loosersTextView)
        
        verticalStackView.addArrangedSubview(pointsStackView)
        pointsStackView.addArrangedSubview(pointsLabel)
        pointsStackView.addArrangedSubview(pointsTextView)
        
        verticalStackView.addArrangedSubview(placesStackView)
        placesStackView.addArrangedSubview(placesLabel)
        placesStackView.addArrangedSubview(placesTextView)
        
        verticalStackView.addArrangedSubview(pointsExtendedStackView)
        pointsExtendedStackView.addArrangedSubview(pointsExtendedLabel)
        pointsExtendedStackView.addArrangedSubview(pointsExtendedTextView)
        
        verticalStackView.addArrangedSubview(professionsStackView)
        professionsStackView.addArrangedSubview(professionsLabel)
        professionsStackView.addArrangedSubview(professionsTextView)
        
        verticalStackView.addArrangedSubview(expansionsStackView)
        expansionsStackView.addArrangedSubview(expansionsLabel)
        expansionsStackView.addArrangedSubview(expansionsTextView)
        
        verticalStackView.addArrangedSubview(scenariosStackView)
        scenariosStackView.addArrangedSubview(scenariosLabel)
        scenariosStackView.addArrangedSubview(scenariosTextView)
        
        verticalStackView.addArrangedSubview(difficultyStackView)
        difficultyStackView.addArrangedSubview(difficultyLabel)
        difficultyStackView.addArrangedSubview(difficultyTextView)
        
        verticalStackView.addArrangedSubview(winSwitchStackView)
        winSwitchStackView.addArrangedSubview(winSwitchLabel)
        winSwitchStackView.addArrangedSubview(winSwitch)
        
        verticalStackView.addArrangedSubview(roundsLeftStackView)
        roundsLeftStackView.addArrangedSubview(roundsLeftLabel)
        roundsLeftStackView.addArrangedSubview(roundsLeftTextView)
        
        verticalStackView.addArrangedSubview(additionalSwitchStackView)
        additionalSwitchStackView.addArrangedSubview(additionalSwitchLabel)
        additionalSwitchStackView.addArrangedSubview(additionalSwitch)
        
        verticalStackView.addArrangedSubview(additionalStackView)
        additionalStackView.addArrangedSubview(additionalLabel)
        additionalStackView.addArrangedSubview(additionalTextView)
        
        verticalStackView.addArrangedSubview(additionalSecondStackView)
        additionalSecondStackView.addArrangedSubview(additionalSecondLabel)
        additionalSecondStackView.addArrangedSubview(additionalSecondTextView)
        
        verticalStackView.addArrangedSubview(additionalThirdStackView)
        additionalThirdStackView.addArrangedSubview(additionalThirdLabel)
        additionalThirdStackView.addArrangedSubview(additionalThirdTextView)
        
        verticalStackView.addArrangedSubview(dateStackView)
        dateStackView.addArrangedSubview(dateLabel)
        dateStackView.addArrangedSubview(dateTextView)
        
        verticalStackView.addArrangedSubview(timeStackView)
        timeStackView.addArrangedSubview(timeLabel)
        timeStackView.addArrangedSubview(timeTextView)
        
        verticalStackView.addArrangedSubview(locationStackView)
        locationStackView.addArrangedSubview(locationLabel)
        locationStackView.addArrangedSubview(locationTextView)
        
        verticalStackView.addArrangedSubview(imageView)
    }
    
    func hideAllStackViews() {
        gameStackView.isHidden = true
        playersStackView.isHidden = true
        winnersStackView.isHidden = true
        loosersStackView.isHidden = true
        pointsStackView.isHidden = true
        placesStackView.isHidden = true
        pointsExtendedStackView.isHidden = true
        professionsStackView.isHidden = true
        expansionsStackView.isHidden = true
        scenariosStackView.isHidden = true
        difficultyStackView.isHidden = true
        winSwitchStackView.isHidden = true
        roundsLeftStackView.isHidden = true
        additionalSwitchStackView.isHidden = true
        additionalStackView.isHidden = true
        additionalSecondStackView.isHidden = true
        additionalThirdStackView.isHidden = true
        dateStackView.isHidden = true
        timeStackView.isHidden = true
        locationStackView.isHidden = true
        imageView.isHidden = true
    }
    
    func getVisibleLabels() -> [UILabel] {
        var visibleLabels = [UILabel]()
        for subview in verticalStackView.arrangedSubviews {
            if let stackView = subview as? UIStackView {
                if !stackView.isHidden {
                    for stackViewSubview in stackView.arrangedSubviews {
                        if let label = stackViewSubview as? UILabel {
                            visibleLabels.append(label)
                        }
                    }
                }
            }
        }
        return visibleLabels
    }
}


