//
//  PVPCellBackgroundView.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 04/04/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//

import UIKit

//Cell used to display all games
class PVPCellBackgroundView: UIView {
    
    var leftColor: UIColor!
    var rightColor: UIColor!
    
    convenience init(frame: CGRect, leftColor: UIColor, rightColor: UIColor) {
        self.init(frame: frame)
        self.leftColor = leftColor
        self.rightColor = rightColor
        setup()
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
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
        shapeLayer.lineWidth = Constants.Cell.lineWidth
        shapeLayer.position = CGPoint(x: 0, y: 0)
        self.layer.addSublayer(shapeLayer)
        
        shapeLayer.path = bottomPath.cgPath
        shapeLayer.lineWidth = Constants.Cell.lineWidth
        self.layer.addSublayer(shapeLayer)
        
        
        let gradientFramePath = createBezierPath(x: 0, y: 0, radius: Constants.Cell.radius)
        let gradient = CAGradientLayer()
        gradient.frame = gradientFramePath.bounds
        gradient.colors = [leftColor.cgColor, rightColor.cgColor]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 0)
        
        let shapeMask = CAShapeLayer()
        shapeMask.path = path.cgPath
        gradient.mask = shapeMask
        self.layer.addSublayer(gradient)
    }
    
    func createBezierPath(x: CGFloat, y: CGFloat, radius: CGFloat) -> UIBezierPath {
        let path = UIBezierPath()
        
        //Top line
        path.move(to: CGPoint(x: x + radius, y: y))
        path.addLine(to: CGPoint(x: self.frame.width - x - radius, y: y))
        
        //Top-right arc
        var centerPoint = CGPoint(x: self.frame.width - x - radius, y: y + radius)
        path.addArc(withCenter: centerPoint, radius: radius, startAngle: CGFloat(3*Double.pi / 2), endAngle: 0, clockwise: true)
        
        //Right line
        //        path.move(to: CGPoint(x: self.frame.width - x, y: y + radius))
        path.addLine(to: CGPoint(x: self.frame.width - x, y: self.frame.height - y - radius))
        
        //Right-bottom arc
        centerPoint = CGPoint(x: self.frame.width - x - radius, y: self.frame.height - y - radius)
        path.addArc(withCenter: centerPoint, radius: radius, startAngle: 0, endAngle: CGFloat(Double.pi / 2), clockwise: true)
        
        //Bottom line
        //        path.move(to: CGPoint(x: self.frame.width - x - radius, y: self.frame.height - y))
        path.addLine(to: CGPoint(x: x + radius, y: self.frame.height - y))
        
        //Bottom-left line
        centerPoint = CGPoint(x: x + radius, y: self.frame.height - y - radius)
        path.addArc(withCenter: centerPoint, radius: radius, startAngle: CGFloat(Float.pi/2), endAngle: CGFloat(Float.pi), clockwise: true)
        
        //Left line
        //        path.move(to: CGPoint(x: x, y: self.frame.height - y - radius))
        path.addLine(to: CGPoint(x: x, y: y + radius))
        
        //Top-left arc
        centerPoint = CGPoint(x: x + radius, y: y + radius)
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
