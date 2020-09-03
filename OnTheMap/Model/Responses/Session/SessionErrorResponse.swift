//
//  SessionErrorResponse.swift
//  OnTheMap
//
//  Created by Márcio Oliveira on 9/3/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

import Foundation

struct SessionErrorResponse: Codable {
    let status: Int
    let error: String
}

extension SessionErrorResponse: LocalizedError {
    var errorDescription: String? {
        return error
    }
}
