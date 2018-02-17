//
//  CLLocationManagerExtension.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 14/02/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//

import UIKit
import CoreLocation

extension CLLocationManager {
    
    func locationToString(location: CLLocation?, textView: UITextView) {
        let geocoder = CLGeocoder()
        guard let location = location else { return }
        geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
            if error == nil {
                let placemark = placemarks?.first
                if let city = placemark?.subAdministrativeArea, let street = placemark?.name {
                    textView.text = "\(city), \(street)"
                }
            }
//            else {
//                let long = location.coordinate.longitude < 0 ? "\(-location.coordinate.longitude)W" : "\(location.coordinate.longitude)E"
//                let lat = location.coordinate.latitude < 0 ? "\(-location.coordinate.latitude)S" : "\(location.coordinate.latitude)N"
//                textView.text = "\(long), \(lat)"
//            }
        })
        return
    }
}
