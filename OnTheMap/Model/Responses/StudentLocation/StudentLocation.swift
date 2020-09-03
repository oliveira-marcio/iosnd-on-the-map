//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by Márcio Oliveira on 8/26/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

import Foundation

struct StudentLocation: Codable {
    let createdAt: String
    let firstName: String
    let lastName: String
    let latitude: Double
    let longitude: Double
    let mapString: String
    let mediaURL: String
    let objectId: String
    let uniqueKey: String
    let updatedAt: String
}
