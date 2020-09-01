//
//  GatewayFactory.swift
//  OnTheMap
//
//  Created by Márcio Oliveira on 8/25/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

import Foundation

class GatewayFactory {
    static let shared: Gateway = CommandLine.arguments.contains("--mockAPI") ? MockGateway() : HttpGateway()
    
    private init() {}
}
