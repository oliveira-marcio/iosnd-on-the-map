//
//  ViewController.swift
//  OnTheMap
//
//  Created by Márcio Oliveira on 8/25/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

import UIKit
import MapKit

class StudentLocationsMapViewController: UIViewController, MKMapViewDelegate, AddLocationDelegate {

    @IBOutlet weak var mapView: MKMapView!

    let gateway = GatewayFactory.create()
    
    var studentLocations: [StudentLocation]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.studentLocations
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.mapView.delegate = self
        // self.getStudentLocations()
        // MARK: TODO For testing purposes. Replace for commented out code above later
        self.handleStudentLocationsResponse(
            studentLocations: [
                StudentLocation(
                    createdAt: "2015-02-25T01:10:38.103Z",
                    firstName: "Jarrod",
                    lastName: "Parkes",
                    latitude: 34.7303688,
                    longitude: -86.5861037,
                    mapString: "Huntsville, Alabama ",
                    mediaURL: "https://www.linkedin.com/in/jarrodparkes",
                    objectId: "JhOtcRkxsh", uniqueKey: "996618664",
                    updatedAt: "2015-03-09T22:04:50.315Z"
                )
            ],
            error: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadMapAnnotations()
    }
    
    @IBAction func getStudentLocations() {
        gateway.getStudentLocations(completion: handleStudentLocationsResponse(studentLocations:error:))
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
        
        self.mapView.showAnnotations(annotations, animated: true)
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
    
    @IBAction func addLocation(_ sender: Any) {
        performSegue(withIdentifier: "showAddLocation", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let targetController = segue.destination as! UINavigationController
        let informationPostingVC = targetController.topViewController as! InformationPostingViewController
        informationPostingVC.addLocationDelegate = self
    }
    
    func onLocationAdded() {
        self.getStudentLocations()
    }
}
