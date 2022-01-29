//
//  Album.swift
//  JSONPlaceholder
//
//  Created by Bill Dunay on 4/20/20.
//  Copyright © 2020 Bill Dunay. All rights reserved.
//

import Foundation

public struct Album: Codable, Hashable {
    public enum CodingKeys: String, CodingKey {
        case userId = "userId"
        case identifier = "id"
        case title = "title"
    }
    
    public let userId: UInt
    public let identifier: UInt
    public let title: String
    
    public init(userId: UInt, identifier: UInt, title: String) {
        self.userId = userId
        self.identifier = identifier
        self.title = title
    }
}
