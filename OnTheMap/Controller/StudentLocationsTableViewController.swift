//
//  StudentLocationsTableViewController.swift
//  OnTheMap
//
//  Created by Márcio Oliveira on 8/27/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

import UIKit

class StudentLocationsTableViewController: UITableViewController {

    @IBOutlet weak var studentLocationsTableView: UITableView!
    
    let gateway = GatewayFactory.create()
    
    var studentLocations: [StudentLocation]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.studentLocations
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.studentLocationsTableView.reloadData()
    }
    
    @IBAction func getStudentLocations() {
        gateway.getStudentLocations(completion: handleStudentLocationsResponse(studentLocations:error:))
    }
    
    func handleStudentLocationsResponse(studentLocations: [StudentLocation], error: Error?) {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.studentLocations = studentLocations
        self.studentLocationsTableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.studentLocations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentLocationTableViewCell", for: indexPath)
        let studentLocation = self.studentLocations[indexPath.row]
        
        cell.imageView?.image = UIImage(named: "icon_pin")
        cell.textLabel?.text = "\(studentLocation.firstName) \(studentLocation.lastName)"
        cell.detailTextLabel?.text = studentLocation.mediaURL

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let studentLocationURL = self.studentLocations[indexPath.row].mediaURL
        let validstudentLocationURL = studentLocationURL.hasPrefix("http") ? studentLocationURL : "http://\(studentLocationURL)"
        if let mediaURL = URL(string: validstudentLocationURL) {
            UIApplication.shared.open(mediaURL)
        }
    }
}
