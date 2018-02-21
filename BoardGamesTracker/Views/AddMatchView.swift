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
    var additionalTextStackView = UIStackView()
    var switchStackView = UIStackView()
    var dateStackView = UIStackView()
    var timeStackView = UIStackView()
    var locationStackView = UIStackView()
    var imageViewStackView = UIStackView()
    
    //MARK: - All labels
    var gameLabel = UILabel()
    var playersLabel =  UILabel()
    var winnersLabel = UILabel()
    var loosersLabel = UILabel()
    var pointsLabel = UILabel()
    var additionalLabel = UILabel()
    var switchLabel = UILabel()
    var dateLabel = UILabel()
    var timeLabel = UILabel()
    var locationLabel = UILabel()
    
    //MARK: - All text views
    var gameTextView = AddMatchTextView()
    var playersTextView = AddMatchTextView()
    var winnersTextView = AddMatchTextView()
    var loosersTextView = AddMatchTextView()
    var pointsTextView = AddMatchTextView()
    var additionalTextView = AddMatchTextView()
    var dateTextView = AddMatchTextView()
    var timeTextView = AddMatchTextView()
    var locationTextView = AddMatchTextView()
    
    var mySwitch = UISwitch()
    
    var imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        verticalStackView.axis = .vertical
        addSubviews()
        hideAllStackViews()
        
        gameLabel.text = "Name"
        playersLabel.text = "Players"
        pointsLabel.text = "Points"
        winnersLabel.text = "Winners"
        loosersLabel.text = "Loosers"
        switchLabel.text = "Did you win?"
        dateLabel.text = "Date"
        timeLabel.text = "Time"
        locationLabel.text = "Location"
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setTranslatesAutoresizingMaskIntoConstraintToFalse()
        
        verticalStackView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor).isActive = true
        verticalStackView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor).isActive = true
        verticalStackView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor).isActive = true
        verticalStackView.spacing = 8
        for view in verticalStackView.arrangedSubviews {
            if view != imageView {
                view.heightAnchor.constraint(equalToConstant: 40).isActive = true
            }
        }
        
        
        
        //All labes have the same leading and trailing anchors
        gameLabel.leadingAnchor.constraint(equalTo: playersLabel.leadingAnchor).isActive = true
        playersLabel.leadingAnchor.constraint(equalTo: pointsLabel.leadingAnchor).isActive = true
        pointsLabel.leadingAnchor.constraint(equalTo: winnersLabel.leadingAnchor).isActive = true
        winnersLabel.leadingAnchor.constraint(equalTo: loosersLabel.leadingAnchor).isActive = true
        loosersLabel.leadingAnchor.constraint(equalTo: dateLabel.leadingAnchor).isActive = true
        dateLabel.leadingAnchor.constraint(equalTo: timeLabel.leadingAnchor).isActive = true
        timeLabel.leadingAnchor.constraint(equalTo: locationLabel.leadingAnchor).isActive = true
        locationLabel.leadingAnchor.constraint(equalTo: additionalLabel.leadingAnchor).isActive = true
        additionalLabel.leadingAnchor.constraint(equalTo: switchLabel.leadingAnchor).isActive = true
        
        gameLabel.trailingAnchor.constraint(equalTo: playersLabel.trailingAnchor).isActive = true
        playersLabel.trailingAnchor.constraint(equalTo: pointsLabel.trailingAnchor).isActive = true
        pointsLabel.trailingAnchor.constraint(equalTo: winnersLabel.trailingAnchor).isActive = true
        winnersLabel.trailingAnchor.constraint(equalTo: loosersLabel.trailingAnchor).isActive = true
        loosersLabel.trailingAnchor.constraint(equalTo: dateLabel.trailingAnchor).isActive = true
        dateLabel.trailingAnchor.constraint(equalTo: timeLabel.trailingAnchor).isActive = true
        timeLabel.trailingAnchor.constraint(equalTo: locationLabel.trailingAnchor).isActive = true
        locationLabel.trailingAnchor.constraint(equalTo: additionalLabel.trailingAnchor).isActive = true
        additionalLabel.trailingAnchor.constraint(equalTo: switchLabel.trailingAnchor).isActive = false
        
        switchStackView.distribution = .fillProportionally
        
        imageView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor).isActive = true

        
        
        
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
        
        additionalTextStackView.translatesAutoresizingMaskIntoConstraints = false
        additionalLabel.translatesAutoresizingMaskIntoConstraints = false
        additionalTextView.translatesAutoresizingMaskIntoConstraints = false
        
        switchStackView.translatesAutoresizingMaskIntoConstraints = false
        switchLabel.translatesAutoresizingMaskIntoConstraints = false
        mySwitch.translatesAutoresizingMaskIntoConstraints = false
        
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
        
        verticalStackView.addArrangedSubview(additionalTextStackView)
        additionalTextStackView.addArrangedSubview(additionalLabel)
        additionalTextStackView.addArrangedSubview(additionalTextView)
        
        verticalStackView.addArrangedSubview(switchStackView)
        switchStackView.addArrangedSubview(switchLabel)
        switchStackView.addArrangedSubview(mySwitch)
        
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
        additionalTextStackView.isHidden = true
        switchStackView.isHidden = true
        dateStackView.isHidden = true
        timeStackView.isHidden = true
        locationStackView.isHidden = true
        imageView.isHidden = true
    }
}


