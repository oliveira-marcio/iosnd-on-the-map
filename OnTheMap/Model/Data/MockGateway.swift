//
//  MockGateway.swift
//  OnTheMap
//
//  Created by Márcio Oliveira on 8/25/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

import Foundation

struct MockGateway: Gateway {
    func get() -> String {
        return "Mocked data"
    }
}
