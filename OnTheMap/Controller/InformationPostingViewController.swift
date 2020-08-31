//
//  InformationPostingViewController.swift
//  OnTheMap
//
//  Created by Márcio Oliveira on 8/27/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

import UIKit

class InformationPostingViewController: UIViewController {
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var mediaURLTextField: UITextField!
    
    @IBAction func cancelAddLocation(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func findLocation() {
        self.performSegue(withIdentifier: "showLocationResults", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let mapViewController = segue.destination as! InformationPostingMapViewController
        mapViewController.location = self.locationTextField.text ?? ""
        mapViewController.latitude = 40.6892574
        mapViewController.longitude = -74.0446083
        mapViewController.mediaURL = self.mediaURLTextField.text ?? ""
    }
}
