//
//  PieChartView.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 10/03/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//

import UIKit

class PieChartView: UIView {
    
    //dataSet and dataName must have the same indexes, i.e.
    //dataSet[0] corrseponds to name dataName[0]
    var dataSet: [Int]!
    var dataName: [String]!
    var radius: CGFloat!
    var title: String?
    
    //Maximum amount of letters in word.
    var truncating: Int?
    
    //Colors can be predefined or randomly generated
    var colorsArray: [UIColor]?
    var dataLabels: [String]?
    
    var lastAngle: CGFloat = 0
    var labels: [UILabel]!
    
    
    //MARK: - Initializers
    convenience init(dataSet: [Int], dataName: [String], dataLabels: [String]?, colorsArray: [UIColor]?, title: String?, radius: CGFloat, truncating: Int?, x: CGFloat, y: CGFloat, width: CGFloat) {
        let frame = CGRect(x: x, y: y, width: width, height: 2 * radius + 25 + 10)
        self.init(frame: frame)
        self.dataSet = dataSet
        self.radius = radius
        self.dataName = dataName
        self.truncating = truncating
        self.colorsArray = colorsArray
        self.title = title
        self.dataLabels = dataLabels
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    
    
    //MARK: - Creating view
    func setup() {
        
        if let title = title {
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: bounds.width, height: 20))
            addSubview(label)
            label.numberOfLines = 0
            label.font = UIFont.boldSystemFont(ofSize: 21)
            label.textAlignment = .center
            label.textColor = UIColor.black
            label.backgroundColor = UIColor.clear
            label.text = title
            addSubview(label)
        }
        
        
        //Calcualtes sum of all data
        let dataSetSum = { () -> Int in
            var sum = 0
            for data in self.dataSet {
                sum += data
            }
            return sum
        }()
        
        let offsetX: CGFloat = 10
        let offsetY: CGFloat = 20
        
        for i in 0..<dataSet.count {
            //Creates pie chart
            let shapeLayerPieChart = CAShapeLayer()
            shapeLayerPieChart.path = createPieChartPath(dataSetSum: dataSetSum, data: dataSet[i], offsetX: offsetX, offsetY: offsetY).cgPath
            
            //Pie chart colors are either chosen by user or generated randomly
            var color: UIColor!
            if let colors = colorsArray {
                color = colors[i]
            } else {
                color = UIColor.init(red: CGFloat(drand48()), green: CGFloat(drand48()), blue: CGFloat(drand48()), alpha: 1)
            }
            shapeLayerPieChart.fillColor = color.cgColor
            shapeLayerPieChart.lineWidth = 0.5
            shapeLayerPieChart.strokeColor = UIColor.black.cgColor
            shapeLayerPieChart.position = CGPoint(x: 0, y: 0)
            self.layer.addSublayer(shapeLayerPieChart)
            
            //Then labels are added at given position
            let x: CGFloat = radius * 2 + 25 + offsetX
            let y: CGFloat = 0 + 15 * CGFloat(i) + offsetY
            let label = UILabel(frame: CGRect(x: x, y: y, width: self.frame.width -  shapeLayerPieChart.frame.width, height: 21))
            label.numberOfLines = 1
            
            
            //Calculates percent and sets it to have only 1 decimal place
            let percent = Float(dataSet[i]) / Float(dataSetSum) * 100
            let percentShort = String.init(format: "%.1f%", percent)
            var dataLabel = "\(dataSet[i])(\(percentShort)%)"
            if let labels = dataLabels {
                dataLabel = labels[i]
            }
            let temp = dataName[i] as NSString
            //Truncates string if it's too long
            if let truncating = truncating, dataName[i].count >= truncating {
                let range = NSRange.init(location: truncating, length: dataName[i].count - truncating)
                let name = temp.replacingCharacters(in: range, with: "...")
                label.text = "\(name) - \(dataLabel)"
            } else {
                label.text = "\(dataName[i]) - \(dataLabel)"
            }
            label.textAlignment = .left
            label.font = UIFont.systemFont(ofSize: 10)
            if y + 15 < self.frame.height {
                addSubview(label)
            }
            
            //Sets square side
            let squareSide: CGFloat = 10
            
            //Add square with given color next to the label
            let shapeLayerSquare = CAShapeLayer()
            shapeLayerSquare.path = createSquarePath(x: x - 15, y: label.frame.midY - squareSide / 2, height: squareSide).cgPath
            
            shapeLayerSquare.fillColor = color.cgColor
            shapeLayerSquare.lineWidth = 1
            shapeLayerSquare.strokeColor = UIColor.black.cgColor
            self.layer.addSublayer(shapeLayerSquare)
        }
    }
    
    
    //MARK: - Bezier Paths
    //Creates sectir of pie chart
    func createPieChartPath(dataSetSum: Int, data: Int, offsetX: CGFloat, offsetY: CGFloat) -> UIBezierPath {
        let path = UIBezierPath()
        let center = CGPoint(x: radius + offsetX, y: radius + offsetY)
        let sum = CGFloat(dataSetSum)
        let data = CGFloat(data)
        let startingAngle = lastAngle
        let endingAngle = startingAngle + data / sum * 2.0 * CGFloat.pi
        lastAngle = endingAngle
        
        path.move(to: center)
        path.addArc(withCenter: center, radius: radius, startAngle: startingAngle, endAngle: endingAngle, clockwise: true)
        return path
    }
    
    //Creates square path
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
