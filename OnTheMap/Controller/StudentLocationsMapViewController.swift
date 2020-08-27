//
//  ViewController.swift
//  OnTheMap
//
//  Created by Márcio Oliveira on 8/25/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

import UIKit
import MapKit

class StudentLocationsMapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var studentLocations: [StudentLocation]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.studentLocations
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.mapView.delegate = self

        let gateway = GatewayFactory.create()
        gateway.getStudentLocations(completion: handleStudentLocationsResponse(studentLocations:error:))
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadMapAnnotations()
    }
    
    func handleStudentLocationsResponse(studentLocations: [StudentLocation], error: Error?) {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.studentLocations = studentLocations
        self.loadMapAnnotations()
    }
    
    func loadMapAnnotations() {
        var annotations = [MKPointAnnotation]()
        
        for studentLocation in self.studentLocations {
            let lat = CLLocationDegrees(studentLocation.latitude)
            let long = CLLocationDegrees(studentLocation.longitude)
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(studentLocation.firstName) \(studentLocation.lastName)"
            annotation.subtitle = studentLocation.mediaURL
            
            annotations.append(annotation)
        }
        
        self.mapView.addAnnotations(annotations)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView

        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let studentLocationURL = view.annotation?.subtitle! ?? ""
            let validstudentLocationURL = studentLocationURL.hasPrefix("http") ? studentLocationURL : "http://\(studentLocationURL)"
            if let mediaURL = URL(string: validstudentLocationURL) {
                UIApplication.shared.open(mediaURL)
            }
        }
    }
}
