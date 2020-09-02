//
//  Models.swift
//  OnTheMap
//
//  Created by Márcio Oliveira on 8/31/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

import Foundation

struct Auth {
    static var sessionId: String = ""
    static var uniqueKey: String = ""
    static var firstName: String = ""
    static var lastName: String = ""
}

struct LocationModel {
    static var studentLocations = [StudentLocation]()
    static var currentObjectId: String = ""
}
