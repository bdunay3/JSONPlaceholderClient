//
//  Photo.swift
//  JSONPlaceholder
//
//  Created by Bill Dunay on 4/20/20.
//  Copyright © 2020 Bill Dunay. All rights reserved.
//

import Foundation

public struct Photo: Codable, Hashable {
    public enum CodingKeys: String, CodingKey {
        case albumId = "albumId"
        case identifier = "id"
        case title = "title"
        case urlString = "url"
        case thumbnailUrlString = "thumbnailUrl"
    }
    
    public let albumId: UInt
    public let identifier: UInt
    public let title: String
    public let urlString: String
    public let thumbnailUrlString: String
    
    init(albumId: UInt, identifier: UInt, title: String, urlString: String, thumbnailUrlString: String) {
        self.albumId = albumId
        self.identifier = identifier
        self.title = title
        self.urlString = urlString
        self.thumbnailUrlString = thumbnailUrlString
    }
}
