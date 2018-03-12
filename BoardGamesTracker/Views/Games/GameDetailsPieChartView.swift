//
//  GameDetailsPieChartView.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 12/03/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//

import UIKit

class GameDetailsPieChartView: UIView {
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
        label.text = "Winning"
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    convenience init(frame: CGRect, dataSet: [Int], dataName: [String]) {
        self.init(frame: frame)
        pieChart = PieChartView(dataSet: dataSet, dataName: dataName, radius: 80, frame: CGRect.init(x: 0, y: 25, width: frame.width, height: frame.height - 25), truncating: 999, colorsArray: [UIColor.blue, UIColor.red, UIColor.orange])
        addSubview(pieChart)
    }
}
