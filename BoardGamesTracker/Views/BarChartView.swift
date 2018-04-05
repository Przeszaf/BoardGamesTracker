//
//  BarChartView.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 10/03/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//

import UIKit

class BarChartView: UIView {
    var dataSet: [Int]!
    var dataSetMapped: [Int]!
    var newDataSet: [Int]?
    var xAxisLabels: [String]?
    var barGapWidth: CGFloat!
    var title: String?
    var labelsRotated: Bool!
    var reverse: Bool!
    var truncating: Int?
    var minX: Int!
    var maxX: Int!
    var step: Int!
    
    convenience init(dataSet: [Int]?, dataSetMapped: [Int]?, newDataSet: [Int]?, xAxisLabels: [String]?, barGapWidth: CGFloat, reverse: Bool, labelsRotated: Bool, truncating: Int?, title: String?, frame: CGRect) {
        self.init(frame: frame)
        self.dataSet = dataSet
        self.newDataSet = newDataSet
        self.xAxisLabels = xAxisLabels
        self.barGapWidth = barGapWidth
        self.reverse = reverse
        self.labelsRotated = labelsRotated
        self.truncating = truncating
        self.dataSetMapped = dataSetMapped
        self.title = title
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
        
        if let title = title {
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width, height: 20))
            label.text = title
            label.textAlignment = .center
            label.font = UIFont.boldSystemFont(ofSize: 21)
            addSubview(label)
        }
        
        //Setting the offset
        let offsetX: CGFloat = 20
        let offsetYBottom: CGFloat!
        let offsetYTop: CGFloat!
        
        if labelsRotated {
            if truncating == nil, let xAxisLabels = xAxisLabels {
                var maxWidth: CGFloat = 0
                for axisLabel in xAxisLabels {
                    let labelWidth = axisLabel.width(withConstrainedHeight: 200, font: UIFont.systemFont(ofSize: 17))
                    if maxWidth < labelWidth {
                        maxWidth = labelWidth
                    }
                }
                offsetYBottom = maxWidth * 0.7
            } else {
                offsetYBottom = 45
            }
        } else {
            offsetYBottom = 20
        }
        
        if title != nil {
            offsetYTop = 25
        } else {
            offsetYTop = 5
        }
        
        //Creating frame layer
        let shapeLayerFrame = CAShapeLayer()
        shapeLayerFrame.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        shapeLayerFrame.path = createFramePath(x: offsetX, yBottom: offsetYBottom, yTop: offsetYTop).cgPath
        shapeLayerFrame.fillColor = UIColor(red: 1, green: 0.6, blue: 0, alpha: 0.2).cgColor
        
        let gradient = CAGradientLayer()
        gradient.frame = shapeLayerFrame.frame
        gradient.colors = [UIColor.blue.cgColor,
                           UIColor.red.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 1)
        gradient.endPoint = CGPoint(x: 1, y: 0)
        gradient.mask = shapeLayerFrame
        
        self.layer.addSublayer(gradient)
        
        
        //Creating X-Axis
        let shapeLayerXAxis = CAShapeLayer()
        shapeLayerXAxis.path = createXAxisPath(x: offsetX, yBottom: offsetYBottom).cgPath
        shapeLayerXAxis.fillColor = UIColor.clear.cgColor
        shapeLayerXAxis.strokeColor = UIColor.blue.cgColor
        self.layer.addSublayer(shapeLayerXAxis)
        
        //Creating Y-Axis
        let shapeLayerYAxis = CAShapeLayer()
        shapeLayerYAxis.path = createYAxisPath(x: offsetX, yBottom: offsetYBottom, yTop: offsetYTop).cgPath
        shapeLayerYAxis.fillColor = UIColor.clear.cgColor
        shapeLayerYAxis.strokeColor = UIColor.blue.cgColor
        self.layer.addSublayer(shapeLayerYAxis)
        
        
        if dataSetMapped != nil {
            minX = 0
            maxX = 10
        } else {
            //Calculating minimum and maximum value for X axis
            dataSetMinMaxX(dataSet: dataSet)
            
            //Map data
            dataSetMapped = map(dataSet)
        }
        
        
        
        //Setting all neccessery variables
        let width = frame.width - 2 * offsetX
        let height = frame.height - offsetYBottom - offsetYTop - 10
        var barsCount: CGFloat = 11
        let stepYHeight = height / CGFloat(dataSetMapped.max()!)
        var font = UIFont.systemFont(ofSize: 8)
        let normalStepWidth = width / barsCount - 1
        let barWidth = normalStepWidth - barGapWidth
        //If there are fewer labels given, then set barsCount to amount of labels
        if let count = xAxisLabels?.count {
            if count < 11 {
                barsCount = CGFloat(count)
            }
        }
        
        let stepXWidth = width / barsCount - 1
        
        //If we want graph reversed, then to following
        if reverse {
            xAxisLabels = xAxisLabels?.reversed()
            dataSetMapped = dataSetMapped.reversed()
        }
        
        
        for i in 0..<Int(barsCount) {
            //Calculate center X and Y of bar
            let barCenterX: CGFloat = offsetX + stepXWidth / 2 + CGFloat(i) * stepXWidth
            let barY: CGFloat = frame.height - offsetYBottom
            
            //Set string to correct value - either label or num between minX and maxX
            var string = ""
            if let labels = xAxisLabels {
                string = labels[i]
            } else {
                string = String(minX + i * step)
            }
            var label: UILabel!
            //Truncates string if it's too long
            if let truncating = truncating {
                let temp = string as NSString
                if string.count >= truncating {
                    let range = NSRange.init(location: truncating, length: string.count - truncating)
                    let truncatedString = temp.replacingCharacters(in: range, with: "...")
                    string = truncatedString
                }
            }
            
            //calculate width of label
            let labelWidth = string.width(withConstrainedHeight: 20, font: font)
            if labelsRotated {
                //0.54 and 0.84 multipliers are cos(1) and sin(1), i.e. rotation angle,
                //so width and height can be calculated
                font = UIFont.systemFont(ofSize: 10)
                label = UILabel(frame: CGRect(x: barCenterX - labelWidth * 0.54 / 2 - 5, y: barY + labelWidth * 0.84 / 2 - 2, width: 30, height: 20))
                label.transform = CGAffineTransform(rotationAngle: -1)
            } else {
                label = UILabel(frame: CGRect(x: barCenterX - labelWidth / 2, y: barY + 2, width: 30, height: 20))
            }
            
            //Add labels describing bars
            label.text = string
            label.numberOfLines = 1
            label.textAlignment = .center
            label.font = font
            label.sizeToFit()
            addSubview(label)
            
            
            //count - how many bars are on this position
            let count = dataSetMapped[i]
            var bottomY: CGFloat = barY
            for _ in 0..<count {
                //create bar paths
                let barPath = createBarPath(leftX: barCenterX - barWidth / 2, rightX: barCenterX + barWidth / 2, bottomY: bottomY, topY: bottomY - stepYHeight)
                let shapeLayerBar = CAShapeLayer()
                shapeLayerBar.path = barPath.cgPath
                shapeLayerBar.fillColor = UIColor.green.cgColor
                shapeLayerBar.strokeColor = UIColor.black.cgColor
                shapeLayerBar.lineWidth = 0.1
                self.layer.addSublayer(shapeLayerBar)
                bottomY = bottomY - stepYHeight
            }
        }
        
        
        //If there is also newData, then indicate it with different color
        if let newDataSet = newDataSet {
            let newDataSetMapped = map(newDataSet)
            for i in 0..<11 {
                let barCenterX: CGFloat = offsetX + stepXWidth / 2 + CGFloat(i) * stepXWidth
                let newDataCount = newDataSetMapped[i]
                let oldDataCount = dataSetMapped[i]
                let topY: CGFloat = frame.height - offsetYTop - CGFloat(oldDataCount) * stepYHeight
                var bottomY: CGFloat = topY + stepYHeight
                for _ in 0..<newDataCount {
                    let barPath = createBarPath(leftX: barCenterX - barWidth / 2, rightX: barCenterX + barWidth / 2, bottomY: bottomY, topY: bottomY - stepYHeight)
                    let shapeLayerBar = CAShapeLayer()
                    shapeLayerBar.path = barPath.cgPath
                    shapeLayerBar.fillColor = UIColor.init(red: 0, green: 1, blue: 0, alpha: 0.8).cgColor
                    shapeLayerBar.strokeColor = UIColor.brown.cgColor
                    shapeLayerBar.lineWidth = 2
                    self.layer.addSublayer(shapeLayerBar)
                    bottomY = bottomY + stepYHeight
                }
            }
        }
        
        
        //Set 2 ticks with labels
        for i in 1...2 {
            let tickFrame = CAShapeLayer()
            var y: CGFloat = 0
            var string: String = ""
            if dataSetMapped.max()! == 1 {
                string = "\(1)"
                y = frame.height - offsetYBottom - height
            } else if dataSetMapped.max()! % 2 == 1 {
                string = "\((dataSetMapped.max()! - 1) / i)"
                y = frame.height - offsetYBottom - (height - stepYHeight) / CGFloat(i)
            } else {
                string = "\(dataSetMapped.max()! / i)"
                y = frame.height - offsetYBottom - height / CGFloat(i)
            }
            tickFrame.path = createYAxisTickAt(leftX: offsetX, y: y).cgPath
            tickFrame.strokeColor = UIColor(red: 0.5, green: 0, blue: 0, alpha: 0.5).cgColor
            tickFrame.lineWidth = 0.5
            self.layer.addSublayer(tickFrame)
            let labelHeight = string.height(withConstrainedWidth: 20, font: font)
            let label = UILabel(frame: CGRect(x: offsetX - 10, y: y - labelHeight / 2, width: 20, height: 20))
            label.numberOfLines = 1
            label.text = string
            label.textAlignment = .left
            label.font = font
            label.sizeToFit()
            addSubview(label)
        }
    }
    
    //Creates path for frame of bar chart
    func createFramePath(x: CGFloat, yBottom: CGFloat, yTop: CGFloat) -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: x, y: yTop))
        path.addLine(to: CGPoint(x: frame.width - x, y: yTop))
        path.addLine(to: CGPoint(x: frame.width - x, y: frame.height - yBottom))
        path.addLine(to: CGPoint(x: x, y: frame.height - yBottom))
        path.close()
        return path
    }
    
    func createXAxisPath(x: CGFloat, yBottom: CGFloat) -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: x, y: frame.height - yBottom))
        path.addLine(to: CGPoint(x: frame.width - x, y: frame.height - yBottom))
        path.addLine(to: CGPoint(x: frame.width - x - 5, y: frame.height - yBottom - 5))
        path.move(to: CGPoint(x: frame.width - x, y: frame.height - yBottom))
        path.addLine(to: CGPoint(x: frame.width - x - 5, y: frame.height - yBottom + 5))
        return path
    }
    
    
    func createYAxisPath(x: CGFloat, yBottom: CGFloat, yTop: CGFloat) -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: x, y: frame.height - yBottom))
        path.addLine(to: CGPoint(x: x, y: yTop))
        path.addLine(to: CGPoint(x: x - 5, y: yTop + 5))
        path.move(to: CGPoint(x: x, y: yTop))
        path.addLine(to: CGPoint(x: x + 5, y: yTop + 5))
        return path
    }
    
    func createYAxisTickAt(leftX: CGFloat, y: CGFloat) -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: leftX, y: y))
        path.addLine(to: CGPoint(x: frame.width - leftX, y: y))
        return path
    }
    
    func createBarPath(leftX: CGFloat, rightX: CGFloat, bottomY: CGFloat, topY: CGFloat) -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: leftX, y: bottomY))
        path.addLine(to: CGPoint(x: leftX, y: topY))
        path.addLine(to: CGPoint(x: rightX, y: topY))
        path.addLine(to: CGPoint(x: rightX, y: bottomY))
        path.close()
        return path
    }
    
    
    //Set minimum and maximum values for X-axis if not given
    func dataSetMinMaxX(dataSet: [Int]) {
        guard let max = dataSet.last else { return }
        guard let min = dataSet.first else { return }
        var barsNumber = 0
        for step in 1...50 {
            let maxValue = max - max % step
            let minValue = min - min % step
            let diff = maxValue - minValue
            let bars = diff / step + 1
            if bars <= 11 {
                barsNumber = bars
                maxX = maxValue
                minX = minValue
                self.step = step
                break
            }
        }
        while barsNumber < 11 {
            if barsNumber % 2 == 0 && minX != 0 {
                minX = minX - step
            } else {
                maxX = maxX + step
            }
            barsNumber += 1
        }
    }
    
    
    //Map dataSet to better suitable format, where it indicates how tall the bars should be, e.g.
    //dataSetMapped[i] indicates height of i'th bar
    func map(_ dataSet: [Int]) -> [Int] {
        var dataSetMapped = [Int](repeating: 0, count: 11)
        if let count = xAxisLabels?.count {
            if count < 11 {
                dataSetMapped = [Int](repeating: 0, count: count)
            }
        }
        for data in dataSet {
            let index = (data - minX) / step
            dataSetMapped[index] += 1
        }
        return dataSetMapped
    }
    
}
