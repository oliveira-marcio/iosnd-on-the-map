//
//  AddStudentLocation.swift
//  OnTheMap
//
//  Created by Márcio Oliveira on 9/3/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

import Foundation

struct AddStudentLocation: Codable {
    let uniqueKey: String
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: String
    let latitude: Double
    let longitude: Double
}
