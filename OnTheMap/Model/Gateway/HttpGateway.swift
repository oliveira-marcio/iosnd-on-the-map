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
        case getUserData
        case logout
        
        var stringValue: String {
            switch self {
            case .getStudentLocations: return Endpoints.base + "/StudentLocation?order=-updatedAt"
            case .createStudentLocations: return Endpoints.base + "/StudentLocation"
            case .updateStudentLocation(let objectId): return Endpoints.base + "/StudentLocation/\(objectId)"
            case .login: return Endpoints.base + "/session"
            case .getUserData: return Endpoints.base + "/users/\(Auth.uniqueKey)"
            case .logout: return Endpoints.base + "/session"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    private func taskForPOSTAndPUTRequests<RequestType: Encodable, ResponseType: Decodable>(url: URL, httpMethod: String, requestBody: RequestType, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode(requestBody)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }

            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch let error {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                print("Parse error: \(error)")
            }
        }
        task.resume()
    }
    
    func login(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        MockGateway().login(username: username, password: password) { (success, error) in
             completion(success, error)
        }
    }
    
    func fetchUserData(completion: @escaping (Bool, Error?) -> Void) {
        enum SerializationError: Error {
            case missing(String)
        }
        
        let request = URLRequest(url: Endpoints.getUserData.url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(false, error)
                }
                return
            }
            
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
                
                DispatchQueue.main.async {
                    completion(true, nil)
                }
            } catch {
                print("Parse error: \(error)")
                DispatchQueue.main.async {
                    completion(false, error)
                }
            }
        }
        task.resume()
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
        let requestBody = AddStudentLocation(
            uniqueKey: Auth.uniqueKey,
            firstName: Auth.firstName,
            lastName: Auth.lastName,
            mapString: searchString,
            mediaURL: mediaURL,
            latitude: latitude,
            longitude: longitude
        )
        
        taskForPOSTAndPUTRequests(url: Endpoints.createStudentLocations.url, httpMethod: "POST", requestBody: requestBody, responseType: AddStudentLocationResponse.self) { (response, error) in
            if let response = response {
                LocationModel.currentObjectId = response.objectId
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    func updateStudentLocation(objectId: String, latitude: Double, longitude: Double, searchString: String, mediaURL: String, completion: @escaping (Bool, Error?) -> Void) {
        let requestBody = AddStudentLocation(
            uniqueKey: Auth.uniqueKey,
            firstName: Auth.firstName,
            lastName: Auth.lastName,
            mapString: searchString,
            mediaURL: mediaURL,
            latitude: latitude,
            longitude: longitude
        )
        
        taskForPOSTAndPUTRequests(url: Endpoints.updateStudentLocation(objectId).url, httpMethod: "PUT", requestBody: requestBody, responseType: UpdateStudentLocationResponse.self) { (response, error) in
            if let _ = response {
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
}
