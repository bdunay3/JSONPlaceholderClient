//
//  Todo.swift
//  JSONPlaceholder
//
//  Created by Bill Dunay on 4/20/20.
//  Copyright © 2020 Bill Dunay. All rights reserved.
//

import Foundation

public struct Todo: Hashable {
    public let userId: UInt
    public let identifier: UInt
    public let title: String
    public let isCompleted: Bool
    
    public init(userId: UInt, identifier: UInt, title: String, isCompleted: Bool) {
        self.userId = userId
        self.identifier = identifier
        self.title = title
        self.isCompleted = isCompleted
    }
}

extension Todo: Codable {
    enum CodingKeys: String, CodingKey {
        case userId = "userId"
        case identifier = "id"
        case title = "title"
        case isCompleted = "completed"
    }
}
