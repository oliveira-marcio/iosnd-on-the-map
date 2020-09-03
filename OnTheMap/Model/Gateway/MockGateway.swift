//
//  MockGateway.swift
//  OnTheMap
//
//  Created by Márcio Oliveira on 8/25/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

import Foundation

struct MockGateway: Gateway {
    func loadDataFromAsset<ResponseType: Decodable>(asset: String, responseType: ResponseType.Type, responseHasUdacityPrefix: Bool = false, completion: @escaping (ResponseType?, Error?) -> Void) {
        guard let path = Bundle.main.path(forResource: asset, ofType: "json") else {
            completion(nil, nil)
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let newData = responseHasUdacityPrefix ? data.subdata(in: 5..<data.count) : data /* exclude Udacity prefix response */
                
                do {
                    let decoder = JSONDecoder()
                    let responseObject = try decoder.decode(ResponseType.self, from: newData)
                    completion(responseObject, nil)
                } catch let error {
                    completion(nil, error)
                    print("Parse error: \(error)")
                }
            } catch let error {
                completion(nil, error)
                print("File error: \(error)")
            }
        })
    }
    
    func login(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        loadDataFromAsset(asset: "post-session", responseType: SessionResponse.self, responseHasUdacityPrefix: true) { (response, error) in
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
    
    func logout(completion: @escaping () -> Void) {
        Auth.sessionId = ""
        Auth.uniqueKey = ""
        Auth.firstName = ""
        Auth.lastName = ""
        
        LocationModel.studentLocations = [StudentLocation]()
        LocationModel.currentObjectId = ""
        
        print("Logged out")
        completion()
    }
    
    func fetchUserData(completion: @escaping (Bool, Error?) -> Void) {
        guard let path = Bundle.main.path(forResource: "get-user-data", ofType: "json") else {
            completion(false, nil)
            return
        }
        
        enum SerializationError: Error {
            case missing(String)
        }
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            let newData = data.subdata(in: 5..<data.count) /* exclude Udacity prefix response */
            
            do {
                let json = try JSONSerialization.jsonObject(with: newData, options: []) as! [String: Any]
                
                guard let firstName = json["first_name"] as? String else {
                    throw SerializationError.missing("first_name")
                }
                
                guard let lastName = json["last_name"] as? String else {
                    throw SerializationError.missing("last_name")
                }
                
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
        loadDataFromAsset(asset: "post-student-location", responseType: AddStudentLocationResponse.self, responseHasUdacityPrefix: false) { (response, error) in
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
