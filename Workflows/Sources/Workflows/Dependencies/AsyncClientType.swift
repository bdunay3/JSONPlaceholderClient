//
//  RESTAsyncClient.swift
//  
//
//  Created by Bill Dunay on 1/29/22.
//

import Foundation
import Models

public protocol AsyncClientType {
    func getUsers() async throws -> [User]
    func getTodos(for user: User) async throws -> [Todo]
    func getPosts(for user: User) async throws -> [Post]
    func getPost(for postId: UInt) async throws -> Post
    func getComments(for post: Post) async throws -> [Comment]
}

public protocol AsyncClientTypeProviding {
    var asyncClient: AsyncClientType { get }
}
