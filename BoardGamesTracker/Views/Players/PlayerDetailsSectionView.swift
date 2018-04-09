//
//  PlayerDetailsSectionView.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 15/02/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//

import UIKit

class PlayerDetailsSectionView: UIView {
    
    var titleLabel = UILabel()
    var matchesCountLabel = UILabel()
    
    var winRatioLabel = UILabel()
    
    var averagePointsLabel = UILabel()
    var maxPointsLabel = UILabel()
    
    
    var expandButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let view = UIView(frame: frame)
        addSubview(view)
        view.addSubview(titleLabel)
        view.addSubview(expandButton)
        view.addSubview(winRatioLabel)
        view.addSubview(averagePointsLabel)
        view.addSubview(maxPointsLabel)
        
        averagePointsLabel.isHidden = true
        maxPointsLabel.isHidden = true
        
        winRatioLabel.font = UIFont.systemFont(ofSize: 12)
        averagePointsLabel.font = UIFont.systemFont(ofSize: 12)
        maxPointsLabel.font = UIFont.systemFont(ofSize: 12)
        
        expandButton.backgroundColor = UIColor.blue
        
        setup()
    }
    
    override func layoutSubviews() {
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        expandButton.translatesAutoresizingMaskIntoConstraints = false
        matchesCountLabel.translatesAutoresizingMaskIntoConstraints = false
        winRatioLabel.translatesAutoresizingMaskIntoConstraints = false
        averagePointsLabel.translatesAutoresizingMaskIntoConstraints = false
        maxPointsLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = 0
        
        titleLabel.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: expandButton.leadingAnchor).isActive = true
        
        winRatioLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        winRatioLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        
        averagePointsLabel.leadingAnchor.constraint(equalTo: winRatioLabel.leadingAnchor).isActive = true
        averagePointsLabel.topAnchor.constraint(equalTo: winRatioLabel.bottomAnchor).isActive = true
        
        maxPointsLabel.leadingAnchor.constraint(equalTo: averagePointsLabel.trailingAnchor, constant: 10).isActive = true
        maxPointsLabel.centerYAnchor.constraint(equalTo: averagePointsLabel.centerYAnchor).isActive = true
        
        expandButton.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor).isActive = true
        expandButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        expandButton.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor).isActive = true
        expandButton.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor).isActive = true
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    
    func setup() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = createBezierPath().cgPath
        shapeLayer.strokeColor = Constants.Header.strokeColor
        shapeLayer.lineWidth = Constants.Header.lineWidth
        shapeLayer.position = CGPoint(x: 0, y: 68)
        self.layer.addSublayer(shapeLayer)
    }
    
    //Creates path at the bottom of view
    func createBezierPath() -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 10, y: 0))
        path.addLine(to: CGPoint(x: bounds.width - 10, y: 0))
        // see previous code for creating the Bezier path
        return path
    }
    
    
}
