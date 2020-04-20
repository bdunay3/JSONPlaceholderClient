//
//  Album.swift
//  JSONPlaceholder
//
//  Created by Bill Dunay on 4/20/20.
//  Copyright © 2020 Bill Dunay. All rights reserved.
//

import Foundation

struct Album: Codable, Hashable {
    enum CodableKeys: String, CodingKey {
        case userId = "userId"
        case identifier = "id"
        case title = "title"
    }
    
    let userId: UInt
    let identifier: UInt
    let title: String
}
