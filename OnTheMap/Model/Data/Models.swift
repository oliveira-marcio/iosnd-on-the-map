//
//  Models.swift
//  OnTheMap
//
//  Created by Márcio Oliveira on 8/31/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

import Foundation

struct Auth {
    // MARK: TODO - Should be empty. Just for test purposes.
    static var sessionId: String = ""
    static var uniqueKey: String = ""
    static var firstName: String = "Márcio"
    static var lastName: String = "Oliveira"
}

struct LocationModel {
    static var studentLocations = [StudentLocation]()
    static var currentObjectId: String = ""
}
