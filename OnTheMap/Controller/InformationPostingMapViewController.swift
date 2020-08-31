//
//  InformationPostingMapViewController.swift
//  OnTheMap
//
//  Created by Márcio Oliveira on 8/27/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

import UIKit
import MapKit

protocol AddLocationDelegate {
    func onLocationAdded()
}

class InformationPostingMapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var searchString = ""
    var country = ""
    var latitude = 0.0
    var longitude = 0.0
    var mediaURL = ""
    
    var addLocationDelegate: AddLocationDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.delegate = self
        self.loadMapResults()
    }
    
    func loadMapResults() {
        let annotation = MKPointAnnotation()
        
        var title = self.searchString
        if !country.isEmpty {
            title += ", \(country)"
        }
        
        annotation.title = title
        annotation.coordinate = CLLocationCoordinate2D(
            latitude: CLLocationDegrees(self.latitude),
            longitude: CLLocationDegrees(self.longitude)
        )
        
        self.mapView.showAnnotations([annotation], animated: true)
        self.mapView.selectAnnotation(annotation, animated: false)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView

        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    @IBAction func addLocation(_ sender: Any) {
        self.dismiss(animated: true) {
            self.addLocationDelegate?.onLocationAdded()
        }
    }
}
