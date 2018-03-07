//
//  WelcomeView.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 01/03/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//

import UIKit

@IBDesignable class WelcomePlayerView: UIView {
    
    override func draw(_ rect: CGRect) {
        
        let frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
        let context = UIGraphicsGetCurrentContext()!
        
        let path = UIBezierPath()
        
        UIColor.gray.setStroke()
        path.lineWidth = 2
        path.move(to: CGPoint(x: 10, y: 10))
        path.addLine(to: CGPoint(x: frame.width - 10, y: 10))
        
        path.move(to: CGPoint(x: 10, y: frame.height - 10))
        path.addLine(to: CGPoint(x: frame.width - 10, y: frame.height - 10))
        path.stroke()
        
        

        let nameLabel = UILabel(frame: CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height))
        nameLabel.numberOfLines = 0
        nameLabel.textAlignment = .center
        nameLabel.backgroundColor = UIColor.clear
        nameLabel.textColor = Constants.Global.mainTextColor
        nameLabel.font = UIFont.boldSystemFont(ofSize: 30)
        nameLabel.text = "Hello, Przemek!"
        UIGraphicsBeginImageContext(frame.size)
        nameLabel.layer.render(in: context)
    }
}
