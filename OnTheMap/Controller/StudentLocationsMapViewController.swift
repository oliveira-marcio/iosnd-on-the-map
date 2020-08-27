//
//  ViewController.swift
//  OnTheMap
//
//  Created by Márcio Oliveira on 8/25/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

import UIKit

class StudentLocationsMapViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gateway = GatewayFactory.create()
        gateway.getStudentLocations(completion: handleStudentLocationsResponse(studentLocations:error:))
        
    }
    
    func handleStudentLocationsResponse(studentLocations: [StudentLocation], error: Error?) {
        label.text = studentLocations.description
    }
}
