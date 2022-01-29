//
//  Post.swift
//  JSONPlaceholder
//
//  Created by Bill Dunay on 4/20/20.
//  Copyright © 2020 Bill Dunay. All rights reserved.
//

import Foundation

public struct Post: Codable, Hashable {
    public enum CodingKeys: String, CodingKey {
        case userId = "userId"
        case identifier = "id"
        case title = "title"
        case body = "body"
    }
    
    public let userId: UInt
    public let identifier: UInt
    public let title: String
    public let body: String
    
    public init(userId: UInt, identifier: UInt, title: String, body: String) {
        self.userId = userId
        self.identifier = identifier
        self.title = title
        self.body = body
    }
}
