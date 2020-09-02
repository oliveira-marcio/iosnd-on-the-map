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

    // MARK: - Outlets and global variables

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var finishButton: CustomButton!
    
    var searchString = ""
    var country = ""
    var latitude = 0.0
    var longitude = 0.0
    var mediaURL = ""
    
    var addLocationDelegate: AddLocationDelegate?
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.delegate = self
        self.loadMapResults()
    }
    
    private func loadMapResults() {
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
    
    // MARK: - Map View Delegate

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
    
    // MARK: - Add Location and Handler

    @IBAction func addLocation(_ sender: Any) {
        self.setAddingLocation(true)
        if LocationModel.currentObjectId.isEmpty {
            GatewayFactory.shared.addStudentLocation(
                latitude: self.latitude,
                longitude: self.longitude,
                searchString: self.searchString,
                mediaURL: self.mediaURL,
                completion: handleAddLocationResponse(success:error:)
            )
        } else {
            GatewayFactory.shared.updateStudentLocation(
                objectId: LocationModel.currentObjectId,
                latitude: self.latitude,
                longitude: self.longitude,
                searchString: self.searchString,
                mediaURL: self.mediaURL,
                completion: handleAddLocationResponse(success:error:)
            )
        }
    }
    
    private func handleAddLocationResponse(success: Bool, error: Error?) {
        if success {
            self.dismiss(animated: true) {
                self.addLocationDelegate?.onLocationAdded()
            }
        } else {
            ErrorUtils.showError(from: self, title: AddLocationErrors.title, message: AddLocationErrors.unknownError)
        }
        
        self.setAddingLocation(false)
    }
    
    private func setAddingLocation(_ addingLocation: Bool) {
        self.finishButton.isEnabled = !addingLocation
        addingLocation ? self.activityIndicatorView.startAnimating() : self.activityIndicatorView.stopAnimating()
    }
}
