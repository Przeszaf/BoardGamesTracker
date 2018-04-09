//
//  PhotoViewController.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 04/04/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//

import UIKit
import MapKit

class PhotoDetailsViewController: UIViewController, MKMapViewDelegate {
    
    var match: Match!
    var photoDetailsView: PhotoDetailsView!
    
    //MARK: - Lifecycle of ViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoDetailsView = PhotoDetailsView(frame: view.frame)
        
        view.backgroundColor = UIColor.clear
        view.isOpaque = false
        view.alpha = 1
        let blurEffect = UIBlurEffect(style: .regular)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = self.view.bounds
        view.addSubview(blurView)
        
        let imageData = match.image! as Data
        let image = UIImage(data: imageData, scale: 1)
        photoDetailsView.imageView.image = image
        
        let annotation = MKPointAnnotation()
        if match.longitude != 0, match.latitude != 0 {
            annotation.coordinate = CLLocationCoordinate2D(latitude: match.latitude, longitude: match.longitude)
            print(annotation.coordinate)
            photoDetailsView.mapView.addAnnotation(annotation)
        }
        
        let span : MKCoordinateSpan = MKCoordinateSpanMake(0.02, 0.02)
        let location : CLLocationCoordinate2D = annotation.coordinate
        let region : MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        photoDetailsView.mapView.setRegion(region, animated: true)
        
        view.addSubview(photoDetailsView)
    }
    
    //Dismiss VC if touches began
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        dismiss(animated: true, completion: nil)
    }
    
    
}
