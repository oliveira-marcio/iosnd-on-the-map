//
//  APIFactory.swift
//  OnTheMap
//
//  Created by Márcio Oliveira on 8/25/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

import Foundation

class GatewayFactory {
    class func create() -> Gateway {
        return CommandLine.arguments.contains("--mockAPI") ? MockGateway() : HttpGateway()
    }
}
