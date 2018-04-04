//
//  PhotoDetailsView.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 04/04/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//

import UIKit
import MapKit

class PhotoDetailsView: UIView {
    
    var mapView: MKMapView!
    var imageView: UIImageView!
    var button: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        mapView = MKMapView()
        imageView = UIImageView()
        button = UIButton()
        imageView.contentMode = .scaleAspectFit
        
        addSubview(button)
        addSubview(imageView)
        addSubview(mapView)
        button.setTitle("Show match", for: .normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor).isActive = true
        button.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor).isActive = true
        button.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor).isActive = true
        
        imageView.topAnchor.constraint(equalTo: button.bottomAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: self.frame.height / 2).isActive = true
        
        
        mapView.topAnchor.constraint(equalTo: imageView.bottomAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor).isActive = true
        mapView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor).isActive = true
    }
}
