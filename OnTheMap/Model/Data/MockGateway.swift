//
//  MockGateway.swift
//  OnTheMap
//
//  Created by Márcio Oliveira on 8/25/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

import Foundation

struct MockGateway: Gateway {
    func getStudentLocations(completion: @escaping ([StudentLocation], Error?) -> Void) {
        guard let path = Bundle.main.path(forResource: "get-student-locations", ofType: "json") else {
            completion([], nil)
            return
        }

        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            do {
                let decoder = JSONDecoder()
                let responseObject = try decoder.decode(StudentLocationsResults.self, from: data)
                completion(responseObject.results, nil)
            } catch let error {
                completion([], nil)
                print("Parse error: \(error)")
            }
        } catch let error {
            completion([], nil)
            print("File error: \(error)")
        }
    }    
}
