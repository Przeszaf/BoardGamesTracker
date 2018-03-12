//
//  LastGamesBarChart.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 12/03/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//

import UIKit

@IBDesignable class LastGamesBarChartView: UIView {
    var label: UILabel!
    var barChart: BarChartView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        label = UILabel(frame: CGRect(x: 0, y: 0, width: bounds.width, height: 20))
        addSubview(label)
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 21)
        label.textAlignment = .center
        label.textColor = UIColor.black
        label.backgroundColor = UIColor.clear
        label.text = "Matches in last weeks"
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    convenience init(frame: CGRect, dataSet: [Int], xAxisLabels: [String]) {
        self.init(frame: frame)
        barChart = BarChartView(dataSet: dataSet, frame: CGRect(x: 0, y: 5, width: frame.width, height: frame.height - 20), reverse: true, labelsRotated: true, newDataSet: nil, xAxisLabels: xAxisLabels)
        addSubview(barChart)
    }
    
    
}
