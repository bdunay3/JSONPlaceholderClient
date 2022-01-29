//
//  MockComments.swift
//  
//
//  Created by Bill Dunay on 2/21/22.
//

import Foundation
import Models

#if DEBUG

extension Comment {
    static var mockCommentList: [Comment] {
        [
            Comment(postId: 0, identifier: 0, name: "John Smith", email: "jsmith@example.com", body: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam non."),
            Comment(postId: 0, identifier: 1, name: "Bob Smith", email: "bsmith@example.com", body: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam non."),
            Comment(postId: 0, identifier: 2, name: "Frank Smith", email: "fsmith@example.com", body: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam non."),
        ]
    }
}

#endif
