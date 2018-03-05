//
//  HomeLogoView.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 28/02/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//

import UIKit

@IBDesignable class HomeLogoView: UIView {
    
    @IBInspectable var startGradientColor: UIColor = UIColor.red
    @IBInspectable var endGradientColor: UIColor = UIColor.white
//    @IBInspectable var textColor: UIColor = UIColor.red
//    var textFont: UIFont = UIFont.boldSystemFont(ofSize: 48)
    
    override func draw(_ rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext()!
        let colors = [startGradientColor.cgColor, endGradientColor.cgColor]
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        let colorLocations: [CGFloat] = [0.0, 1.0]
        
        let gradient = CGGradient(colorsSpace: colorSpace, colors: colors as CFArray, locations: colorLocations)!
        
        let startPoint = CGPoint.zero
        let endPoint = CGPoint(x: 0, y: bounds.height)
        
        context.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: [])
        
//        let frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
//        let nameLabel = UILabel(frame: frame)
//        nameLabel.numberOfLines = 0
//        nameLabel.textAlignment = .center
//        nameLabel.backgroundColor = UIColor.clear
//        nameLabel.textColor = textColor
//        nameLabel.font = textFont
//        nameLabel.text = "Board Games Tracker"
//        UIGraphicsBeginImageContext(frame.size)
//        nameLabel.layer.render(in: context)
    }
}
