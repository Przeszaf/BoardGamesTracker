//
//  GameStatisticsView.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 06/02/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//

import UIKit

class GameDetailsHeaderView: UIView {
    
    //MARK: - All Stack views needed
    var horizontalStackView = UIStackView()
    var verticalStackView = UIStackView()
    var verticalStackViewLeft = UIStackView()
    var verticalStackViewRight = UIStackView()
    
    //MARK: - All labels
    var totalMatchesLabel = UILabel()
    var totalPlayersLabel =  UILabel()
    var totalTimePlayedLabel = UILabel()
    var averageTimePlayedLabel = UILabel()
    
    var maxPointsLabel = UILabel()
    var minPointsLabel = UILabel()
    var averagePointsLabel = UILabel()
    var medianPointsLabel = UILabel()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        verticalStackView.axis = .vertical
        horizontalStackView.axis = .horizontal
        verticalStackViewLeft.axis = .vertical
        verticalStackViewRight.axis = .vertical
        
        verticalStackView.distribution = .fillProportionally
        horizontalStackView.distribution = .equalSpacing
        verticalStackViewRight.distribution = .fillProportionally
        verticalStackViewLeft.distribution = .fillProportionally
        addSubviews()
        
        minPointsLabel.isHidden = true
        maxPointsLabel.isHidden = true
        averagePointsLabel.isHidden = true
        medianPointsLabel.isHidden = true
        
        backgroundColor = Constants.Global.backgroundColor
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setTranslatesAutoresizingMaskIntoConstraintToFalse()
        
        verticalStackView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor).isActive = true
        verticalStackView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor).isActive = true
        verticalStackView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor).isActive = true
        verticalStackView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor).isActive = true
        
        verticalStackView.topAnchor.constraint(equalTo: verticalStackView.topAnchor).isActive = true
        
        verticalStackViewRight.topAnchor.constraint(equalTo: horizontalStackView.topAnchor).isActive = true
        
        verticalStackViewLeft.topAnchor.constraint(equalTo: horizontalStackView.topAnchor).isActive = true
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    
    func setTranslatesAutoresizingMaskIntoConstraintToFalse() {
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        verticalStackViewRight.translatesAutoresizingMaskIntoConstraints = false
        verticalStackViewLeft.translatesAutoresizingMaskIntoConstraints = false
        
        totalMatchesLabel.translatesAutoresizingMaskIntoConstraints = false
        totalPlayersLabel.translatesAutoresizingMaskIntoConstraints = false
        minPointsLabel.translatesAutoresizingMaskIntoConstraints = false
        maxPointsLabel.translatesAutoresizingMaskIntoConstraints = false
        averagePointsLabel.translatesAutoresizingMaskIntoConstraints = false
        medianPointsLabel.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    
    func addSubviews() {
        addSubview(verticalStackView)
        
        verticalStackView.addArrangedSubview(horizontalStackView)
        
        horizontalStackView.addArrangedSubview(verticalStackViewLeft)
        horizontalStackView.addArrangedSubview(verticalStackViewRight)
        
        verticalStackViewLeft.addArrangedSubview(totalMatchesLabel)
        verticalStackViewRight.addArrangedSubview(totalPlayersLabel)
        
        verticalStackViewLeft.addArrangedSubview(minPointsLabel)
        verticalStackViewRight.addArrangedSubview(maxPointsLabel)
        verticalStackViewLeft.addArrangedSubview(averagePointsLabel)
        verticalStackViewRight.addArrangedSubview(medianPointsLabel)
        
        verticalStackView.addArrangedSubview(totalTimePlayedLabel)
        verticalStackView.addArrangedSubview(averageTimePlayedLabel)
        
    }
    
    func setup() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = createBezierPath().cgPath
        shapeLayer.strokeColor = Constants.Header.strokeColor
        shapeLayer.lineWidth = Constants.Header.lineWidth
        shapeLayer.position = CGPoint(x: 0, y: bounds.height - 5)
        self.layer.addSublayer(shapeLayer)
        
    }
    
    func createBezierPath() -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 10, y: 0))
        path.addLine(to: CGPoint(x: bounds.width - 10, y: 0))
        // see previous code for creating the Bezier path
        return path
    }
}
