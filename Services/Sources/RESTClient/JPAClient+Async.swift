//
//  JPAClientAsyncType.swift
//  JSONPlaceholderAPI
//
//  Created by Bill Dunay on 7/1/21.
//  Copyright © 2021 Bill Dunay. All rights reserved.
//

import Foundation
import Models

extension JPAClient {
    public func getUsers() async throws -> [User] {
        let requestURL = environment.url(endPoint: Endpoint.users, queryParameters: [])
        return try await performFetch(at: requestURL)
    }
    
    public func getTodos(for user: User) async throws -> [Todo] {
        let requestURL = environment.url(endPoint: Endpoint.todos, queryParameters: [
            URLQueryItem(name: "userId", value: "\(user.identifier)")
        ])
        return try await performFetch(at: requestURL)
    }
    
    public func getPosts(for user: User) async throws -> [Post] {
        let requestURL = environment.url(endPoint: Endpoint.posts, queryParameters: [
            URLQueryItem(name: "userId", value: "\(user.identifier)")
        ])
        return try await performFetch(at: requestURL)
    }
    
    public func getPost(for postId: UInt) async throws -> Post {
        let requestURL = environment.url(endPoint: Endpoint.posts, queryParameters: [
            URLQueryItem(name: "id", value: "\(postId)")
        ])
        let postGroup: [Post] = try await performFetch(at: requestURL)
        guard let post = postGroup.first else { throw HTTPError.wrongDataReturned }
        return post
    }
    
    public func getComments(for post: Post) async throws -> [Comment] {
        let requestURL = environment.url(endPoint: Endpoint.comments, queryParameters: [
            URLQueryItem(name: "postId", value: "\(post.identifier)")
        ])
        
        return try await performFetch(at: requestURL)
    }
    
    private func performFetch<T: Decodable>(at url: URL) async throws -> T {
        let (data, response) = try await session.data(from: url)
        guard let response = response as? HTTPURLResponse else { throw HTTPError.notHttpResponse }
        guard response.statusCode == 200 else { throw HTTPError.statusCode(response.statusCode) }
        
        return try JSONDecoder().decode(T.self, from: data)
    }
}
