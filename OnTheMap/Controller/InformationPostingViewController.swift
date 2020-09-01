//
//  InformationPostingViewController.swift
//  OnTheMap
//
//  Created by Márcio Oliveira on 8/27/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

import UIKit
import CoreLocation

class InformationPostingViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var mediaURLTextField: UITextField!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var findLocationButton: UIButton!
    
    var searchString: String?
    var latitude: Double?
    var longitude: Double?
    var country: String?
    
    var addLocationDelegate: AddLocationDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchTextField.delegate = self
        self.findLocationButton.isEnabled = false
    }
    
    @IBAction func cancelAddLocation(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var newText = textField.text! as NSString
        newText = newText.replacingCharacters(in: range, with: string) as NSString
        self.findLocationButton.isEnabled = newText.length > 0
        return true
    }
    
    @IBAction func findLocation() {
        guard let searchString = self.searchTextField.text, !searchString.isEmpty else {
            return
        }
        
        self.searchString = searchString
        self.setGeocoding(true)
        
        CLGeocoder().geocodeAddressString(searchString, completionHandler: handleGeocodeResponse(placemarks:error:))
    }
    
    func handleGeocodeResponse(placemarks: [CLPlacemark]?, error: Error?) {
        if let placemark = placemarks?.first {
            if let location = placemark.location {
                self.latitude = location.coordinate.latitude
                self.longitude = location.coordinate.longitude
                self.country = placemark.country
                
                self.performSegue(withIdentifier: "showLocationResults", sender: nil)
            } else {
                self.showGeocodeFailure(message: "Couldn't fetch location coordinates. Please try again.")
            }
        } else {
            self.showGeocodeFailure(message: "Couldn't find a location with provided address. Please try again.")
        }
        
        self.setGeocoding(false)
    }
    
    func setGeocoding(_ geocoding: Bool) {
        self.searchTextField.isEnabled = !geocoding
        self.mediaURLTextField.isEnabled = !geocoding
        self.findLocationButton.isEnabled = !geocoding
        geocoding ? self.activityIndicatorView.startAnimating() : self.activityIndicatorView.stopAnimating()
    }
    
    func showGeocodeFailure(message: String) {
        let alert = UIAlertController(title: "Find Location Failed", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let mapViewController = segue.destination as! InformationPostingMapViewController
        mapViewController.searchString = self.searchString!
        mapViewController.country = self.country!
        mapViewController.latitude = self.latitude!
        mapViewController.longitude = self.longitude!
        mapViewController.mediaURL = self.mediaURLTextField.text ?? ""
        mapViewController.addLocationDelegate = self.addLocationDelegate
    }
}
