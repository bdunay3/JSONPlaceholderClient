//
//  Comment.swift
//  JSONPlaceholder
//
//  Created by Bill Dunay on 4/20/20.
//  Copyright © 2020 Bill Dunay. All rights reserved.
//

import Foundation

public struct Comment: Hashable {
    public let postId: UInt
    public let identifier: UInt
    public let name: String
    public let email: String
    public let body: String
}

extension Comment: Codable {
    enum CodingKeys: String, CodingKey {
        case postId = "postId"
        case identifier = "id"
        case name = "name"
        case email = "email"
        case body = "body"
    }
}
