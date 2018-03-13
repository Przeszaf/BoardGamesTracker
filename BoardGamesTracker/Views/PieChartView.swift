//
//  PieChartView.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 10/03/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//

import UIKit

class PieChartView: UIView {
    
    var dataSet: [Int]!
    var dataName: [String]!
    var radius: CGFloat!
    var lastAngle: CGFloat = 0
    var truncating: Int!
    var colorsArray: [UIColor]?
    
    var labels: [UILabel]!
    
    convenience init(dataSet: [Int], dataName: [String], radius: CGFloat, frame: CGRect, truncating: Int?, colorsArray: [UIColor]?) {
        self.init(frame: frame)
        self.dataSet = dataSet
        self.radius = radius
        self.dataName = dataName
        self.truncating = truncating
        self.colorsArray = colorsArray
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func layoutSubviews() {
    }
    
    
    func setup() {
        //Calcualtes sum of all data
        let dataSetSum = { () -> Int in
            var sum = 0
            for data in self.dataSet {
                sum += data
            }
            return sum
        }()
        
        for i in 0..<dataSet.count {
            //Creates pie chart
            let shapeLayerPieChart = CAShapeLayer()
            shapeLayerPieChart.path = createPieChartPath(dataSetSum: dataSetSum, dataSetIndex: i).cgPath
            
            //Pie chart colors are either chosen by user or generated randomly
            var color: UIColor!
            if let colors = colorsArray {
                color = colors[i]
            } else {
                color = UIColor.init(red: CGFloat(drand48()), green: CGFloat(drand48()), blue: CGFloat(drand48()), alpha: 1)
            }
            shapeLayerPieChart.fillColor = color.cgColor
            shapeLayerPieChart.lineWidth = 2
            shapeLayerPieChart.position = CGPoint(x: 0, y: 0)
            self.layer.addSublayer(shapeLayerPieChart)
            
            //Then labels are added at given position
            let x: CGFloat = radius * 2 + 25
            let y: CGFloat = 0 + 15 * CGFloat(i)
            let label = UILabel(frame: CGRect(x: x, y: y, width: 150, height: 21))
            label.numberOfLines = 1
            
            //Calculates percent and sets it to have only 1 decimal place
            let percent = Float(dataSet[i]) / Float(dataSetSum) * 100
            let percentShort = String.init(format: "%.1f%", percent)
            let temp = dataName[i] as NSString
            //Truncates string if it's too long
            if dataName[i].count >= truncating {
                let range = NSRange.init(location: truncating, length: dataName[i].count - truncating)
                let name = temp.replacingCharacters(in: range, with: "...")
                label.text = "\(name) - \(dataSet[i])(\(percentShort)%)"
            } else {
                label.text = "\(dataName[i]) - \(dataSet[i])(\(percentShort)%)"
            }
            label.textAlignment = .left
            label.font = UIFont.systemFont(ofSize: 10)
            print(label.frame)
            addSubview(label)
            let height: CGFloat = 10
            
            //Add square with given color next to the label
            let shapeLayerSquare = CAShapeLayer()
            shapeLayerSquare.path = createSquarePath(x: x - 15, y: label.frame.midY - height / 2, height: height).cgPath
            
            shapeLayerSquare.fillColor = color.cgColor
            shapeLayerSquare.lineWidth = 1
            shapeLayerSquare.strokeColor = UIColor.black.cgColor
            self.layer.addSublayer(shapeLayerSquare)
        }
    }
    
    func createPieChartPath(dataSetSum: Int, dataSetIndex: Int) -> UIBezierPath {
        let path = UIBezierPath()
        let center = CGPoint(x: radius, y: radius)
        let sum = CGFloat(dataSetSum)
        let data = CGFloat(dataSet[dataSetIndex])
        let startingAngle = lastAngle
        let endingAngle = startingAngle + data / sum * 2.0 * CGFloat.pi
        lastAngle = endingAngle
        print(endingAngle)
        
        path.move(to: center)
        path.addArc(withCenter: center, radius: radius, startAngle: startingAngle, endAngle: endingAngle, clockwise: true)
        return path
    }
    
    func createSquarePath(x: CGFloat, y: CGFloat, height: CGFloat) -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: x, y: y))
        
        path.addLine(to: CGPoint(x: x + height, y: y))
        path.addLine(to: CGPoint(x: x + height, y: y + height))
        path.addLine(to: CGPoint(x: x, y: y + height ))
        path.addLine(to: CGPoint(x: x, y: y))
        return path
    }
    
}
