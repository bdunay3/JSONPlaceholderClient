//
//  Photo.swift
//  JSONPlaceholder
//
//  Created by Bill Dunay on 4/20/20.
//  Copyright © 2020 Bill Dunay. All rights reserved.
//

import Foundation

struct Photo: Codable, Hashable {
    enum CodingKeys: String, CodingKey {
        case albumId = "albumId"
        case identifier = "id"
        case title = "title"
        case urlString = "url"
        case thumbnailUrlString = "thumbnailUrl"
    }
    
    let albumId: UInt
    let identifier: UInt
    let title: String
    let urlString: String
    let thumbnailUrlString: String
}
