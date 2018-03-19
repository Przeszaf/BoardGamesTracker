//
//  AllPlayersHeaderView.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 07/03/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//

import UIKit


//first TableHeaderView for AllPlayersViewController
class AllPlayersHeaderView: UIView {
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
        
        
        //Changing label fontsize for smaller views
        var fontSize: CGFloat = 24
        var font = UIFont.boldSystemFont(ofSize: fontSize)
        while(true) {
            if let labelHeight = label.text?.height(withConstrainedWidth: layoutMarginsGuide.layoutFrame.width, font: font) {
                if labelHeight > frame.height - 15 {
                    font = font.withSize(fontSize - 1)
                    fontSize -= 1
                } else {
                    break
                }
            }
        }
        label.font = font
    }
    
    
    func setup() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = createBezierPath().cgPath
        shapeLayer.strokeColor = Constants.Header.strokeColor
        shapeLayer.lineWidth = Constants.Header.lineWidth
        shapeLayer.position = CGPoint(x: 0, y: bounds.height - 5)
        self.layer.addSublayer(shapeLayer)
        
    }
    
    //Creates bezier path of line at the bottom of view
    func createBezierPath() -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 10, y: 0))
        path.addLine(to: CGPoint(x: bounds.width - 10, y: 0))
        // see previous code for creating the Bezier path
        return path
    }
}
