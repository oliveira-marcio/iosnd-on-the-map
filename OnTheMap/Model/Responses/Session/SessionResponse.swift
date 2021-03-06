//
//  SessionResponse.swift
//  OnTheMap
//
//  Created by Márcio Oliveira on 8/26/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

import Foundation

struct SessionResponse: Codable {
    let account: Account
    let session: Session
}
