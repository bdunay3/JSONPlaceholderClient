//
//  MockPosts.swift
//  
//
//  Created by Bill Dunay on 2/21/22.
//

import Foundation
import Models

#if DEBUG

extension Post {
    static var mockPostList: [Post] {
        [
            Post(userId: 0, identifier: 0, title: "Test Title", body: "Example Body"),
            Post(userId: 0, identifier: 1, title: "Test Title 2", body: "Example Body 2"),
        ]
    }
}

#endif
