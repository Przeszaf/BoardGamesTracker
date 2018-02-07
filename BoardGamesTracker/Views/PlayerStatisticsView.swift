//
//  PlayerStatisticsView.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 07/02/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//

import UIKit

class PlayerStatisticsView: UIView {
    
    //MARK: - All Stack views needed
    var verticalStackView = UIStackView()
    var gameStackView = UIStackView()
    var playersStackView = UIStackView()
    var winnersStackView = UIStackView()
    var loosersStackView = UIStackView()
    var pointsStackView = UIStackView()
    
    //MARK: - All labels
    var gameLabel = UILabel()
    var playersLabel =  UILabel()
    var winnersLabel = UILabel()
    var loosersLabel = UILabel()
    var pointsLabel = UILabel()
    
    //MARK: - All text views
    var gameTextView = AddMatchTextView()
    var playersTextView = AddMatchTextView()
    var winnersTextView = AddMatchTextView()
    var loosersTextView = AddMatchTextView()
    var pointsTextView = AddMatchTextView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        verticalStackView.axis = .vertical
        addSubviews()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setTranslatesAutoresizingMaskIntoConstraintToFalse()
        
        verticalStackView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor).isActive = true
        verticalStackView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor).isActive = true
        verticalStackView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor).isActive = true
        verticalStackView.spacing = 8
        
        gameLabel.leadingAnchor.constraint(equalTo: playersLabel.leadingAnchor).isActive = true
        playersLabel.leadingAnchor.constraint(equalTo: pointsLabel.leadingAnchor).isActive = true
        pointsLabel.leadingAnchor.constraint(equalTo: winnersLabel.leadingAnchor).isActive = true
        winnersLabel.leadingAnchor.constraint(equalTo: loosersLabel.leadingAnchor).isActive = true
        
        gameLabel.trailingAnchor.constraint(equalTo: playersLabel.trailingAnchor).isActive = true
        playersLabel.trailingAnchor.constraint(equalTo: pointsLabel.trailingAnchor).isActive = true
        pointsLabel.trailingAnchor.constraint(equalTo: winnersLabel.trailingAnchor).isActive = true
        winnersLabel.trailingAnchor.constraint(equalTo: loosersLabel.trailingAnchor).isActive = true
        
        
        
        gameLabel.text = "Name"
        playersLabel.text = "Players"
        pointsLabel.text = "Points"
        winnersLabel.text = "Winners"
        loosersLabel.text = "Loosers"
        
        
        let width = max(gameLabel.text!.width(withConstrainedHeight: 100, font: UIFont.systemFont(ofSize: 17)), playersLabel.text!.width(withConstrainedHeight: 100, font: UIFont.systemFont(ofSize: 17)), pointsLabel.text!.width(withConstrainedHeight: 100, font: UIFont.systemFont(ofSize: 17)), winnersLabel.text!.width(withConstrainedHeight: 100, font: UIFont.systemFont(ofSize: 17)), loosersLabel.text!.width(withConstrainedHeight: 100, font: UIFont.systemFont(ofSize: 17)))
        
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
    }
}
