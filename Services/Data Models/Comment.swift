//
//  Comment.swift
//  JSONPlaceholder
//
//  Created by Bill Dunay on 4/20/20.
//  Copyright © 2020 Bill Dunay. All rights reserved.
//

import Foundation

struct Comment: Codable, Hashable {
    enum CodingKeys: String, CodingKey {
        case postId = "postId"
        case identifier = "id"
        case name = "name"
        case email = "email"
        case body = "body"
    }
    
    let postId: UInt
    let identifier: UInt
    let name: String
    let email: String
    let body: String
}
