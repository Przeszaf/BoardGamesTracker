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
        })
        return
    }
}
