//
//  StudentLocationsMapViewController.swift
//  OnTheMap
//
//  Created by Márcio Oliveira on 8/25/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

import UIKit
import MapKit

class StudentLocationsMapViewController: UIViewController, MKMapViewDelegate, AddLocationDelegate {
    
    // MARK: - Outlets and global variables

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var refreshBarButton: UIBarButtonItem!
    
    private var activityIndicatorView = UIActivityIndicatorView()
    private var refreshIndicatorView: UIView?
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.activityIndicatorView.sizeToFit()
        self.activityIndicatorView.color = self.view.tintColor
        self.activityIndicatorView.startAnimating()
        
        self.refreshIndicatorView = refreshBarButton.customView

        self.mapView.delegate = self
        
        self.getStudentLocations()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadMapAnnotations()
    }
    
    // MARK: - Get Student Locations and Handlers

    @IBAction func getStudentLocations() {
        self.setLoadingLocations(true)
        GatewayFactory.shared.getStudentLocations(completion: handleStudentLocationsResponse(studentLocations:error:))
    }
    
    private func handleStudentLocationsResponse(studentLocations: [StudentLocation], error: Error?) {
        self.setLoadingLocations(false)

        if let _ = error {
            ErrorUtils.showError(from: self, title: StudentLocationsErrors.title, message: StudentLocationsErrors.unknownError)
        } else {
            LocationModel.studentLocations = studentLocations
            self.loadMapAnnotations()
        }
    }
    
    private func setLoadingLocations(_ loading: Bool) {
        refreshBarButton.isEnabled = !loading
        refreshBarButton.customView = loading ? self.activityIndicatorView : self.refreshIndicatorView
    }

    private func loadMapAnnotations() {
        var annotations = [MKPointAnnotation]()
        
        for studentLocation in LocationModel.studentLocations {
            let lat = CLLocationDegrees(studentLocation.latitude)
            let long = CLLocationDegrees(studentLocation.longitude)
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(studentLocation.firstName) \(studentLocation.lastName)"
            annotation.subtitle = studentLocation.mediaURL
            
            annotations.append(annotation)
        }
        
        self.mapView.removeAnnotations(self.mapView.annotations)
        self.mapView.showAnnotations(annotations, animated: true)
    }
    
    // MARK: - Map View Delegate
    
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
    
    // MARK: - Start Add Location and Handler
    
    @IBAction func addLocation(_ sender: Any) {
        if LocationModel.currentObjectId.isEmpty {
            performSegue(withIdentifier: "showAddLocation", sender: sender)
        } else {
            let alert = UIAlertController(title: "Attention", message: "You have already posted a student location. Would you like to overwrite current location?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Overwrite", style: .default, handler: { _ in self.performSegue(withIdentifier: "showAddLocation", sender: sender) }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let targetController = segue.destination as! UINavigationController
        let informationPostingVC = targetController.topViewController as! InformationPostingViewController
        informationPostingVC.addLocationDelegate = self
    }
    
    func onLocationAdded() {
        self.getStudentLocations()
    }
    
    // MARK: - Logout

    @IBAction func logout(_ sender: Any) {
        GatewayFactory.shared.logout {
            self.dismiss(animated: true, completion: nil)
        }
    }
}
