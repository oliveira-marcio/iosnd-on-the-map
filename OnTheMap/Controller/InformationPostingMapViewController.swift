//
//  InformationPostingMapViewController.swift
//  OnTheMap
//
//  Created by Márcio Oliveira on 8/27/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

import UIKit

class InformationPostingMapViewController: UIViewController {

    @IBOutlet weak var resultsLabel: UILabel!
    
    var location = ""
    var mediaURL = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.resultsLabel.text = "Results:\n\nLocation: \(location)\nURL: \(mediaURL)"
    }
    
    @IBAction func addLocation(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
