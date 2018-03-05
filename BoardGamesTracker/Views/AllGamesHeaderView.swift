//
//  AllGamesHeaderView.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 28/02/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//

import UIKit

class AllGamesHeaderView: UIView {
    
    var label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        label.textColor = UIColor.black
        label.backgroundColor = UIColor.clear
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func layoutSubviews() {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor).isActive = true
        label.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor).isActive = true
        
    }
    
    func setup() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = createBezierPath().cgPath
        shapeLayer.strokeColor = UIColor.lightGray.cgColor
        shapeLayer.lineWidth = 2
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
