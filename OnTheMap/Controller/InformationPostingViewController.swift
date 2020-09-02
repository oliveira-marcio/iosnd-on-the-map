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
    
    // MARK: - Outlets and global variables

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var mediaURLTextField: UITextField!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var findLocationButton: UIButton!
    
    enum InformationFields: Int {
        case search, mediaURL
    }
    
    var searchString: String?
    var latitude: Double?
    var longitude: Double?
    var country: String?
    
    var addLocationDelegate: AddLocationDelegate?
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchTextField.delegate = self
        self.searchTextField.tag = InformationFields.search.rawValue

        self.mediaURLTextField.delegate = self
        self.mediaURLTextField.tag = InformationFields.mediaURL.rawValue

        self.findLocationButton.isEnabled = false
    }
    
    // MARK: - Text Fields Delegate

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.tag == InformationFields.mediaURL.rawValue {
            return true
        }
        
        var newText = textField.text! as NSString
        newText = newText.replacingCharacters(in: range, with: string) as NSString
        
        self.findLocationButton.isEnabled = newText.length > 0
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - Find Location and Handlers

    @IBAction func findLocation() {
        guard let searchString = self.searchTextField.text, !searchString.isEmpty else {
            return
        }
        
        self.searchString = searchString
        self.setGeocoding(true)
        
        CLGeocoder().geocodeAddressString(searchString, completionHandler: handleGeocodeResponse(placemarks:error:))
    }
    
    private func handleGeocodeResponse(placemarks: [CLPlacemark]?, error: Error?) {
        if let placemark = placemarks?.first {
            if let location = placemark.location {
                self.latitude = location.coordinate.latitude
                self.longitude = location.coordinate.longitude
                self.country = placemark.country
                
                self.performSegue(withIdentifier: "showLocationResults", sender: nil)
            } else {
                ErrorUtils.showError(from: self, title: GeocodeErrors.title, message: GeocodeErrors.invalidCoordinates)
            }
        } else {
            ErrorUtils.showError(from: self, title: GeocodeErrors.title, message: GeocodeErrors.invalidAddress)
        }
        
        self.setGeocoding(false)
    }
    
    private func setGeocoding(_ geocoding: Bool) {
        self.searchTextField.isEnabled = !geocoding
        self.mediaURLTextField.isEnabled = !geocoding
        self.findLocationButton.isEnabled = !geocoding
        geocoding ? self.activityIndicatorView.startAnimating() : self.activityIndicatorView.stopAnimating()
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
    
    // MARK: - Cancel Add Location

    @IBAction func cancelAddLocation(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
