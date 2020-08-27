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
    
    var studentLocations: [StudentLocation]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.studentLocations
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gateway = GatewayFactory.create()
        gateway.getStudentLocations(completion: handleStudentLocationsResponse(studentLocations:error:))
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        label.text = self.studentLocations.description
    }
    
    func handleStudentLocationsResponse(studentLocations: [StudentLocation], error: Error?) {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.studentLocations = studentLocations
        
        label.text = self.studentLocations.description
    }
}
