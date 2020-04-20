//
//  Post.swift
//  JSONPlaceholder
//
//  Created by Bill Dunay on 4/20/20.
//  Copyright © 2020 Bill Dunay. All rights reserved.
//

import Foundation

struct Post: Codable, Hashable {
    enum CodingKeys: String, CodingKey {
        case userId = "userId"
        case identifier = "id"
        case title = "title"
        case body = "body"
    }
    
    let userId: UInt
    let identifier: UInt
    let title: String
    let body: String
}
