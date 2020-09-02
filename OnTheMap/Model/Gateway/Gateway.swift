//
//  Gateway.swift
//  OnTheMap
//
//  Created by Márcio Oliveira on 8/25/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

import Foundation

protocol Gateway {
    func login(username: String, password: String, completion: @escaping (Bool, Error?) -> Void)
    func fetchUserData(completion: @escaping (Bool, Error?) -> Void)
    func getStudentLocations(completion: @escaping ([StudentLocation], Error?) -> Void)
    func addStudentLocation(latitude: Double, longitude: Double, searchString: String, mediaURL: String, completion: @escaping (Bool, Error?) -> Void)
    func updateStudentLocation(objectId: String, latitude: Double, longitude: Double, searchString: String, mediaURL: String, completion: @escaping (Bool, Error?) -> Void)
}
