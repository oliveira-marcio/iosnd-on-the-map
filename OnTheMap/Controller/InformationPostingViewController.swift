//
//  InformationPostingViewController.swift
//  OnTheMap
//
//  Created by Márcio Oliveira on 8/27/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

import UIKit
import CoreLocation

class InformationPostingViewController: UIViewController {
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var mediaURLTextField: UITextField!
    
    var location: String?
    var latitude: Double?
    var longitude: Double?
    
    @IBAction func cancelAddLocation(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func findLocation() {
        guard let address = self.locationTextField.text, !address.isEmpty else {
            return
        }
        
        CLGeocoder().geocodeAddressString(address, completionHandler: {(placemarks, error) -> Void in
            if let placemark = placemarks?.first {
                if let location = placemark.location {
                    self.latitude = location.coordinate.latitude
                    self.longitude = location.coordinate.longitude
                    
                    if let country = placemark.country {
                        self.location = "\(address), \(country)"
                    } else {
                        self.location = address
                    }
                    
                    self.performSegue(withIdentifier: "showLocationResults", sender: nil)
                } else {
                    self.showGeocodeFailure(message: "Couldn't fetch location coordinates. Please try again.")
                }
            } else {
                self.showGeocodeFailure(message: "Couldn't find a location with provided address. Please try again.")
            }
        })
    }
    
    func showGeocodeFailure(message: String) {
        let alert = UIAlertController(title: "Find Location Failed", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let mapViewController = segue.destination as! InformationPostingMapViewController
        mapViewController.location = self.location!
        mapViewController.latitude = self.latitude!
        mapViewController.longitude = self.longitude!
        mapViewController.mediaURL = self.mediaURLTextField.text ?? ""
    }
}
