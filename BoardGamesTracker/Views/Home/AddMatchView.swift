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
    var switchStackView = UIStackView()
    var switchTwoStackView = UIStackView()
    var dateStackView = UIStackView()
    var timeStackView = UIStackView()
    var locationStackView = UIStackView()
    var imageViewStackView = UIStackView()
    
    var dictionaryStackView = UIStackView()
    var additionalStackView = UIStackView()
    var additionalSecondStackView = UIStackView()
    var additionalThirdStackView = UIStackView()
    
    //MARK: - All labels
    var gameLabel = UILabel()
    var playersLabel =  UILabel()
    var winnersLabel = UILabel()
    var loosersLabel = UILabel()
    var pointsLabel = UILabel()
    var switchLabel = UILabel()
    var switchTwoLabel = UILabel()
    var dateLabel = UILabel()
    var timeLabel = UILabel()
    var locationLabel = UILabel()
    
    var dictionaryLabel = UILabel()
    var additionalLabel = UILabel()
    var additionalSecondLabel = UILabel()
    var additionalThirdLabel = UILabel()
    
    //MARK: - All text views
    var gameTextView = AddMatchTextView()
    var playersTextView = AddMatchTextView()
    var winnersTextView = AddMatchTextView()
    var loosersTextView = AddMatchTextView()
    var pointsTextView = AddMatchTextView()
    var dateTextView = AddMatchTextView()
    var timeTextView = AddMatchTextView()
    var locationTextView = AddMatchTextView()
    
    var dictionaryTextView = AddMatchTextView()
    var additionalTextView = AddMatchTextView()
    var additionalSecondTextView = AddMatchTextView()
    var additionalThirdTextView = AddMatchTextView()
    
    var mySwitch = UISwitch()
    var mySwitchTwo = UISwitch()
    
    var imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        verticalStackView.axis = .vertical
        addSubviews()
        hideAllStackViews()
        mySwitch.tintColor = UIColor.white
        mySwitch.backgroundColor = UIColor.white
        mySwitch.layer.cornerRadius = 16
        
        mySwitchTwo.tintColor = UIColor.white
        mySwitchTwo.backgroundColor = UIColor.white
        mySwitchTwo.layer.cornerRadius = 16
        
        gameLabel.text = "Name"
        playersLabel.text = "Players"
        pointsLabel.text = "Points"
        winnersLabel.text = "Winners"
        loosersLabel.text = "Loosers"
        switchLabel.text = "Did you win?"
        switchTwoLabel.text = "???"
        dateLabel.text = "Date"
        timeLabel.text = "Time"
        locationLabel.text = "Location"
        dictionaryLabel.text = "???"
        additionalLabel.text = "???"
        additionalSecondLabel.text = "???"
        additionalThirdLabel.text = "???"
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setTranslatesAutoresizingMaskIntoConstraintToFalse()
        
        verticalStackView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor).isActive = true
        verticalStackView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor).isActive = true
        verticalStackView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor).isActive = true
        verticalStackView.spacing = 8
        
        
        
        //All labes have the same leading and trailing anchors
        gameLabel.leadingAnchor.constraint(equalTo: playersLabel.leadingAnchor).isActive = true
        playersLabel.leadingAnchor.constraint(equalTo: pointsLabel.leadingAnchor).isActive = true
        pointsLabel.leadingAnchor.constraint(equalTo: winnersLabel.leadingAnchor).isActive = true
        winnersLabel.leadingAnchor.constraint(equalTo: loosersLabel.leadingAnchor).isActive = true
        loosersLabel.leadingAnchor.constraint(equalTo: dateLabel.leadingAnchor).isActive = true
        dateLabel.leadingAnchor.constraint(equalTo: timeLabel.leadingAnchor).isActive = true
        timeLabel.leadingAnchor.constraint(equalTo: locationLabel.leadingAnchor).isActive = true
        locationLabel.leadingAnchor.constraint(equalTo: switchLabel.leadingAnchor).isActive = true
        switchLabel.leadingAnchor.constraint(equalTo: gameLabel.leadingAnchor).isActive = true
        dictionaryLabel.leadingAnchor.constraint(equalTo: switchTwoLabel.leadingAnchor).isActive = true
        switchTwoLabel.leadingAnchor.constraint(equalTo: additionalLabel.leadingAnchor).isActive = true
        additionalLabel.leadingAnchor.constraint(equalTo: additionalSecondLabel.leadingAnchor).isActive = true
        additionalSecondLabel.leadingAnchor.constraint(equalTo: additionalThirdLabel.leadingAnchor).isActive = true
        
        gameLabel.trailingAnchor.constraint(equalTo: playersLabel.trailingAnchor).isActive = true
        playersLabel.trailingAnchor.constraint(equalTo: pointsLabel.trailingAnchor).isActive = true
        pointsLabel.trailingAnchor.constraint(equalTo: winnersLabel.trailingAnchor).isActive = true
        winnersLabel.trailingAnchor.constraint(equalTo: loosersLabel.trailingAnchor).isActive = true
        loosersLabel.trailingAnchor.constraint(equalTo: dateLabel.trailingAnchor).isActive = true
        dateLabel.trailingAnchor.constraint(equalTo: timeLabel.trailingAnchor).isActive = true
        timeLabel.trailingAnchor.constraint(equalTo: locationLabel.trailingAnchor).isActive = true
        locationLabel.trailingAnchor.constraint(equalTo: dictionaryLabel.trailingAnchor).isActive = true
        dictionaryLabel.trailingAnchor.constraint(equalTo: additionalLabel.trailingAnchor).isActive = true
        additionalLabel.trailingAnchor.constraint(equalTo: additionalSecondLabel.trailingAnchor).isActive = true
        additionalSecondLabel.trailingAnchor.constraint(equalTo: additionalThirdLabel.trailingAnchor).isActive = true
        
        
        mySwitchTwo.widthAnchor.constraint(equalToConstant: 49).isActive = true
        mySwitch.leadingAnchor.constraint(equalTo: mySwitchTwo.leadingAnchor).isActive = true

        
        locationLabel.trailingAnchor.constraint(equalTo: switchLabel.trailingAnchor).isActive = false
        dictionaryLabel.trailingAnchor.constraint(equalTo: switchTwoLabel.trailingAnchor).isActive = false
        
        switchStackView.distribution = .fillProportionally
        switchTwoStackView.distribution = .fillProportionally
        
        imageView.heightAnchor.constraint(equalToConstant: self.frame.width / 16 * 9).isActive = true

        
        
        
        locationTextView.isEditable = false
        
        
        //Width of labels is set to width of longest string in labels + 8
        let width = max(gameLabel.text!.width(withConstrainedHeight: 100, font: UIFont.systemFont(ofSize: 17)), playersLabel.text!.width(withConstrainedHeight: 100, font: UIFont.systemFont(ofSize: 17)), pointsLabel.text!.width(withConstrainedHeight: 100, font: UIFont.systemFont(ofSize: 17)), winnersLabel.text!.width(withConstrainedHeight: 100, font: UIFont.systemFont(ofSize: 17)), loosersLabel.text!.width(withConstrainedHeight: 100, font: UIFont.systemFont(ofSize: 17)),dateLabel.text!.width(withConstrainedHeight: 100, font: UIFont.systemFont(ofSize: 17)), timeLabel.text!.width(withConstrainedHeight: 100, font: UIFont.systemFont(ofSize: 17)), locationLabel.text!.width(withConstrainedHeight: 100, font: UIFont.systemFont(ofSize: 17)))
        
        gameLabel.widthAnchor.constraint(equalToConstant: width + 8).isActive = true
        
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
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
        
        dictionaryStackView.translatesAutoresizingMaskIntoConstraints = false
        dictionaryLabel.translatesAutoresizingMaskIntoConstraints = false
        dictionaryTextView.translatesAutoresizingMaskIntoConstraints = false
        
        additionalStackView.translatesAutoresizingMaskIntoConstraints = false
        additionalLabel.translatesAutoresizingMaskIntoConstraints = false
        additionalTextView.translatesAutoresizingMaskIntoConstraints = false
        
        additionalSecondStackView.translatesAutoresizingMaskIntoConstraints = false
        additionalSecondLabel.translatesAutoresizingMaskIntoConstraints = false
        additionalSecondTextView.translatesAutoresizingMaskIntoConstraints = false
        
        additionalThirdStackView.translatesAutoresizingMaskIntoConstraints = false
        additionalThirdLabel.translatesAutoresizingMaskIntoConstraints = false
        additionalThirdTextView.translatesAutoresizingMaskIntoConstraints = false
        
        switchStackView.translatesAutoresizingMaskIntoConstraints = false
        switchLabel.translatesAutoresizingMaskIntoConstraints = false
        mySwitch.translatesAutoresizingMaskIntoConstraints = false
        
        switchTwoStackView.translatesAutoresizingMaskIntoConstraints = false
        switchTwoLabel.translatesAutoresizingMaskIntoConstraints = false
        mySwitchTwo.translatesAutoresizingMaskIntoConstraints = false
        
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
        
        verticalStackView.addArrangedSubview(dictionaryStackView)
        dictionaryStackView.addArrangedSubview(dictionaryLabel)
        dictionaryStackView.addArrangedSubview(dictionaryTextView)
        
        verticalStackView.addArrangedSubview(additionalStackView)
        additionalStackView.addArrangedSubview(additionalLabel)
        additionalStackView.addArrangedSubview(additionalTextView)
        
        verticalStackView.addArrangedSubview(additionalSecondStackView)
        additionalSecondStackView.addArrangedSubview(additionalSecondLabel)
        additionalSecondStackView.addArrangedSubview(additionalSecondTextView)
        
        verticalStackView.addArrangedSubview(additionalThirdStackView)
        additionalThirdStackView.addArrangedSubview(additionalThirdLabel)
        additionalThirdStackView.addArrangedSubview(additionalThirdTextView)
        
        verticalStackView.addArrangedSubview(switchStackView)
        switchStackView.addArrangedSubview(switchLabel)
        switchStackView.addArrangedSubview(mySwitch)
        
        verticalStackView.addArrangedSubview(switchTwoStackView)
        switchTwoStackView.addArrangedSubview(switchTwoLabel)
        switchTwoStackView.addArrangedSubview(mySwitchTwo)
        
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
        switchStackView.isHidden = true
        switchTwoStackView.isHidden = true
        dateStackView.isHidden = true
        timeStackView.isHidden = true
        locationStackView.isHidden = true
        imageView.isHidden = true
        
        dictionaryStackView.isHidden = true
        additionalStackView.isHidden = true
        additionalSecondStackView.isHidden = true
        additionalThirdStackView.isHidden = true
    }
}


