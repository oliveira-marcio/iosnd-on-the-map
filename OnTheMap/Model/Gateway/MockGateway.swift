//
//  MockGateway.swift
//  OnTheMap
//
//  Created by Márcio Oliveira on 8/25/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

import Foundation

struct MockGateway: Gateway {
    func loadDataFromAsset<ResponseType: Decodable>(asset: String, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) {
        guard let path = Bundle.main.path(forResource: asset, ofType: "json") else {
            completion(nil, nil)
            return
        }

        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            do {
                let decoder = JSONDecoder()
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                completion(responseObject, nil)
            } catch let error {
                completion(nil, error)
                print("Parse error: \(error)")
            }
        } catch let error {
            completion(nil, error)
            print("File error: \(error)")
        }
    }
    
    func login(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        loadDataFromAsset(asset: "post-session", responseType: SessionResponse.self) { (response, error) in
            if let response = response {
                print("sessionId: \(response.session.id)")
                print("uniqueKey: \(response.account.key)")
                Auth.sessionId = response.session.id
                Auth.uniqueKey = response.account.key
                completion(true, nil)
            } else {
                completion(false, nil)
            }
        }
    }
    
    func fetchUserData(completion: @escaping (Bool, Error?) -> Void) {
        guard let path = Bundle.main.path(forResource: "get-user-data", ofType: "json") else {
            completion(false, nil)
            return
        }

        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                
                let user = json["user"] as! [String: Any]
                let firstName = user["first_name"] as! String
                let lastName = user["last_name"] as! String
                
                print("Name: \(firstName) \(lastName)")
                Auth.firstName = firstName
                Auth.lastName = lastName
                
                completion(true, nil)
            } catch {
                completion(false, nil)
                print("Parse error: \(error)")
            }
        } catch let error {
            completion(false, error)
            print("File error: \(error)")
        }
    }
    
    func getStudentLocations(completion: @escaping ([StudentLocation], Error?) -> Void) {
        loadDataFromAsset(asset: "get-student-locations", responseType: StudentLocationsResults.self) { (response, error) in
            if let response = response {
                completion(response.results, nil)
            } else {
                completion([], nil)
            }
        }
    }
    
    func addStudentLocation(latitude: Double, longitude: Double, searchString: String, mediaURL: String, completion: @escaping (Bool, Error?) -> Void) {
        loadDataFromAsset(asset: "post-student-location", responseType: AddStudentLocationResponse.self) { (response, error) in
            print("latitude: \(latitude)")
            print("longitude: \(longitude)")
            print("searchString: \(searchString)")
            print("mediaURL: \(mediaURL)")

            if let response = response {
                print("objectId: \(response.objectId)")
                LocationModel.currentObjectId = response.objectId
                completion(true, nil)
            } else {
                completion(false, nil)
            }
        }
    }
    
    func updateStudentLocation(objectId: String, latitude: Double, longitude: Double, searchString: String, mediaURL: String, completion: @escaping (Bool, Error?) -> Void) {
        loadDataFromAsset(asset: "put-student-location", responseType: UpdateStudentLocationResponse.self) { (response, error) in
            print("objectId: \(objectId)")

            if let response = response {
                print("updatedAt: \(response.updatedAt)")
                completion(true, nil)
            } else {
                completion(false, nil)
            }
        }
    }
}
