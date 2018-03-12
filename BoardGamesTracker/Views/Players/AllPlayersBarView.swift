//
//  AllPlayersBarView.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 12/03/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//

import UIKit

class AllPlayersBarView: UIView {
    
    var label: UILabel!
    var pieChart: PieChartView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        label = UILabel(frame: CGRect(x: 0, y: 0, width: bounds.width, height: 20))
        addSubview(label)
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 21)
        label.textAlignment = .center
        label.textColor = UIColor.black
        label.backgroundColor = UIColor.clear
        label.text = "Most active players"
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    convenience init(frame: CGRect, dataSet: [Int], dataName: [String]) {
        self.init(frame: frame)
        pieChart = PieChartView(dataSet: dataSet, dataName: dataName, radius: 80, frame: frame, truncating: 14, colorsArray: nil)
        addSubview(pieChart)
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
