//
//  HttpGateway.swift
//  OnTheMap
//
//  Created by Márcio Oliveira on 8/25/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

import Foundation

struct HttpGateway: Gateway {
    func login(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        completion(false, nil)
    }
    
    func fetchUserData(completion: @escaping (Bool, Error?) -> Void) {
        completion(false, nil)
    }
    
    func logout(completion: @escaping () -> Void) {
        completion()
    }
    
    func getStudentLocations(completion: @escaping ([StudentLocation], Error?) -> Void) {
        completion([], nil)
    }
    
    func addStudentLocation(latitude: Double, longitude: Double, searchString: String, mediaURL: String, completion: @escaping (Bool, Error?) -> Void) {
        completion(false, nil)
    }
    
    func updateStudentLocation(objectId: String, latitude: Double, longitude: Double, searchString: String, mediaURL: String, completion: @escaping (Bool, Error?) -> Void) {
        completion(false, nil)
    }
}
