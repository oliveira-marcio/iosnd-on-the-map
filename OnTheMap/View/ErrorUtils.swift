//
//  Utils.swift
//  OnTheMap
//
//  Created by Márcio Oliveira on 9/2/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

import Foundation
import UIKit

class ErrorUtils {
    private init() {}
    
    class func showError(from viewController: UIViewController, title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }
}

struct AuthenticationErrors {
    static let title = "Authentication Failed"
    static let unknownError = "Error fetching user data."
}

struct StudentLocationsErrors {
    static let title = "Student Locations Failed"
    static let unknownError = "Couldn't retrieve student locations. Please try again."
}

struct GeocodeErrors {
    static let title = "Find Location Failed"
    static let invalidCoordinates = "Couldn't fetch location coordinates. Please try again."
    static let invalidAddress = "Couldn't find a location with provided address. Please try again."
}

struct AddLocationErrors {
    static let title = "Add Location Failed"
    static let unknownError = "Something wrong happened. Please try again."
}
