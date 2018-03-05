//
//  CellBackgroundEditingView.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 03/03/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//

import UIKit

//Cell used to display all games
class CellBackgroundEditingView: UIView {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        
        
        let shapeLayer = CAShapeLayer()
        let path = createBezierPath(x: Constants.Cell.offsetX, y: Constants.Cell.offsetY, radius: Constants.Cell.radius)
        let bottomPath = createBottomBezierPath()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor.lightText.cgColor
        shapeLayer.strokeColor = UIColor.lightGray.cgColor
        shapeLayer.lineWidth = 2
        shapeLayer.position = CGPoint(x: 0, y: 0)
        self.layer.addSublayer(shapeLayer)
        
        shapeLayer.path = bottomPath.cgPath
        shapeLayer.lineWidth = Constants.Cell.lineWidth
        self.layer.addSublayer(shapeLayer)
        
        
        let gradientFramePath = createBezierPath(x: 0, y: 0, radius: Constants.Cell.radius)
        
        let gradient = CAGradientLayer()
        gradient.frame = gradientFramePath.bounds
        gradient.colors = [Constants.Cell.gradientStartColor, Constants.Cell.gradientEndColor]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = Constants.Cell.gradientStartPoint
        gradient.endPoint = Constants.Cell.gradientEndPoint
        
        let shapeMask = CAShapeLayer()
        shapeMask.path = path.cgPath
        gradient.mask = shapeMask
        self.layer.addSublayer(gradient)
    }
    
    func createBezierPath(x: CGFloat, y: CGFloat, radius: CGFloat) -> UIBezierPath {
        let path = UIBezierPath()
        
        //Top line
        path.move(to: CGPoint(x: x + radius + 40, y: y))
        path.addLine(to: CGPoint(x: self.frame.width, y: y))
        
        
        //Right line
        path.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height - y))
        
        
        //Bottom line
        if x == 0 {
            path.addLine(to: CGPoint(x: x, y: self.frame.height - y))
        } else {
            path.addLine(to: CGPoint(x: x + 55, y: self.frame.height - y))
        }
        
        //Bottom-left line
        var centerPoint = CGPoint(x: x + radius + 40, y: self.frame.height - y - radius)
        path.addArc(withCenter: centerPoint, radius: radius, startAngle: CGFloat(Float.pi/2), endAngle: CGFloat(Float.pi), clockwise: true)
        
        //Left line
        path.addLine(to: CGPoint(x: x + 40, y: y + radius))
        
        //Top-left arc
        centerPoint = CGPoint(x: x + radius + 40, y: y + radius)
        path.addArc(withCenter: centerPoint, radius: radius, startAngle: CGFloat(Double.pi), endAngle: CGFloat(Double.pi*3 / 2), clockwise: true)
        return path
    }
    
    func createBottomBezierPath() -> UIBezierPath{
        let path = UIBezierPath()
        
        path.lineWidth = 1
        path.move(to: CGPoint(x: 10, y: self.frame.height))
        path.addLine(to: CGPoint(x: self.frame.width - 10, y: self.frame.height))
        return path
    }
    
    
}

