//
//  HttpGateway.swift
//  OnTheMap
//
//  Created by Márcio Oliveira on 8/25/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

import Foundation

struct HttpGateway: Gateway {
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1"
        
        case getStudentLocations
        case createStudentLocations
        case updateStudentLocation(String)
        case login
        case getUserData(String)
        case logout
        
        var stringValue: String {
            switch self {
            case .getStudentLocations: return Endpoints.base + "/StudentLocation?order=-updatedAt"
            case .createStudentLocations: return Endpoints.base + "/StudentLocation"
            case .updateStudentLocation(let objectId): return Endpoints.base + "/StudentLocation/\(objectId)"
            case .login: return Endpoints.base + "/session"
            case .getUserData(let uniqueKey): return Endpoints.base + "/users/\(uniqueKey)"
            case .logout: return Endpoints.base + "/session"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    func login(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        MockGateway().login(username: username, password: password) { (success, error) in
             completion(success, error)
        }
    }
    
    func fetchUserData(completion: @escaping (Bool, Error?) -> Void) {
        MockGateway().fetchUserData() { (success, error) in
             completion(success, error)
        }
    }
    
    func logout(completion: @escaping () -> Void) {
        completion()
    }
    
    func getStudentLocations(completion: @escaping ([StudentLocation], Error?) -> Void) {
        let request = URLRequest(url: Endpoints.getStudentLocations.url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion([], error)
                }
                return
            }

            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(StudentLocationsResults.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject.results, nil)
                }                
            } catch let error {
                DispatchQueue.main.async {
                    completion([], error)
                }
                print("Parse error: \(error)")
            }
        }
        task.resume()
    }
    
    func addStudentLocation(latitude: Double, longitude: Double, searchString: String, mediaURL: String, completion: @escaping (Bool, Error?) -> Void) {
        MockGateway().addStudentLocation(latitude: latitude, longitude: longitude, searchString: searchString, mediaURL: mediaURL) { (success, error) in
             completion(success, error)
        }
    }
    
    func updateStudentLocation(objectId: String, latitude: Double, longitude: Double, searchString: String, mediaURL: String, completion: @escaping (Bool, Error?) -> Void) {
        MockGateway().updateStudentLocation(objectId: objectId, latitude: latitude, longitude: longitude, searchString: searchString, mediaURL: mediaURL) { (success, error) in
             completion(success, error)
        }
    }
}
