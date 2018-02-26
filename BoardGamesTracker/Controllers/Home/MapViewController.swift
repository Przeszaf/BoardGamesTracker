//
//  MapViewController.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 14/02/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//

import UIKit
import MapKit
import Cluster


class MapViewController: UIViewController {
    
    var locations: [CLLocation]!
    var matches: [Match]!
    var annotations = [Annotation]()
    let manager = ClusterManager()
    
    var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView = MKMapView()
        mapView.mapType = .standard
        mapView.frame = view.frame
        mapView.delegate = self
        view.addSubview(mapView)
        
        manager.cellSize = nil
        manager.maxZoomLevel = 17
        manager.minCountForClustering = 2
        manager.shouldRemoveInvisibleAnnotations = false
        manager.clusterPosition = .nearCenter

        for (i, location) in locations.enumerated() {
            let annotation = Annotation()
            annotation.coordinate = location.coordinate
            annotation.title = matches[i].game?.name
            annotation.style = ClusterAnnotationStyle.color(.blue, radius: 25)
            annotations.append(annotation)
        }
        manager.add(annotations)
        manager.reload(mapView, visibleMapRect: mapView.visibleMapRect)
    }
}

    extension MapViewController: MKMapViewDelegate {
        
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? ClusterAnnotation {
            guard let style = annotation.style else { return nil }
            let identifier = "Cluster"
            var view = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            if let view = view as? BorderedClusterAnnotationView {
                view.annotation = annotation
                view.configure(with: style)
            } else {
                view = BorderedClusterAnnotationView(annotation: annotation, reuseIdentifier: identifier, style: style, borderColor: .white)
            }
            return view
        } else {
            guard let annotation = annotation as? Annotation, let style = annotation.style else { return nil }
            let identifier = "Pin"
            var view = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
            if let view = view {
                view.annotation = annotation
            } else {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            }
            if #available(iOS 9.0, *), case let .color(color, _) = style {
                view?.pinTintColor = color
            } else {
                view?.pinTintColor = .green
            }
            return view
        }
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        manager.reload(mapView, visibleMapRect: mapView.visibleMapRect)
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation else { return }
        
        if let cluster = annotation as? ClusterAnnotation {
            var zoomRect = MKMapRectNull
            for annotation in cluster.annotations {
                let annotationPoint = MKMapPointForCoordinate(annotation.coordinate)
                let pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0, 0)
                if MKMapRectIsNull(zoomRect) {
                    zoomRect = pointRect
                } else {
                    zoomRect = MKMapRectUnion(zoomRect, pointRect)
                }
            }
            zoomRect.origin.x -= zoomRect.size.width * 0.1
            zoomRect.origin.y -= zoomRect.size.height * 0.1
            zoomRect.size.height *= 1.2
            zoomRect.size.width *= 1.2
            mapView.setVisibleMapRect(zoomRect, animated: true)
        }
    }
    
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        views.forEach { $0.alpha = 0 }
        UIView.animate(withDuration: 0.35, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [], animations: {
            views.forEach { $0.alpha = 1 }
        }, completion: nil)
    }
}


class BorderedClusterAnnotationView: ClusterAnnotationView {
    let borderColor: UIColor
    
    init(annotation: MKAnnotation?, reuseIdentifier: String?, style: ClusterAnnotationStyle, borderColor: UIColor) {
        self.borderColor = borderColor
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier, style: style)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configure(with style: ClusterAnnotationStyle) {
        super.configure(with: style)
        switch style {
        case .image:
            layer.borderWidth = 0
        case .color:
            layer.borderColor = borderColor.cgColor
            layer.borderWidth = 2
        }
    }
}

