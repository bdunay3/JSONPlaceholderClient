//
//  MockAlbums.swift
//  
//
//  Created by Bill Dunay on 2/21/22.
//

import Foundation
import Models

#if DEBUG

extension Album {
    static var mockAlbumList: [Album] {
        [
            Album(userId: 1, identifier: 0, title: "Album 1"),
            Album(userId: 1, identifier: 1, title: "Album 2")
        ]
    }
}

#endif
