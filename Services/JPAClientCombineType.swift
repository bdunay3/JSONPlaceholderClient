//
//  JPAClientType.swift
//  JSONPlaceholderAPI
//
//  Created by Bill Dunay on 7/1/21.
//  Copyright © 2021 Bill Dunay. All rights reserved.
//

import Combine
import Foundation

public protocol JPAClientCombineType {
    func getUsersTask() -> AnyPublisher<Array<User>, Error>
    func getAlbumsTask(for user: User) -> AnyPublisher<[Album], Error>
    func getUserPostsTask(_ user: User) -> AnyPublisher<Array<Post>, Error>
    func getPostsTask(for postId: UInt) -> AnyPublisher<Array<Post>, Error>
    func getTodosTask(for user: User) -> AnyPublisher<Array<Todo>, Error>
    func getComments(for postId: UInt) -> AnyPublisher<Array<Comment>, Error>
    
    func deleteUser(id: UInt) -> AnyPublisher<Void, Error>
}

private extension JPAClient {
    func runTask_GetJSON<T: Decodable>(for urlRequest: URLRequest, httpMethod: String) -> AnyPublisher<T, Error> {
        var urlRequest = urlRequest
        urlRequest.httpMethod = httpMethod
        
        return session.dataTaskPublisher(for: urlRequest)
        .tryMap { output in
            guard let response = output.response as? HTTPURLResponse else { throw HTTPError.notHttpResponse }
            guard response.statusCode == 200 else { throw HTTPError.statusCode(response.statusCode) }
            
            return output.data
        }
        .decode(type: T.self, decoder: JSONDecoder())
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
}

extension JPAClient: JPAClientCombineType {
    public func getUsersTask() -> AnyPublisher<Array<User>, Error> {
        let requestURL = environment.url(endPoint: Endpoint.users, queryParameters: [])
        let urlRequest = URLRequest(url: requestURL)
        
        return runTask_GetJSON(for: urlRequest, httpMethod: "GET")
    }
    
    public func getAlbumsTask(for user: User) -> AnyPublisher<[Album], Error> {
        let requestURL = environment.url(endPoint: Endpoint.albums, queryParameters: [
            URLQueryItem(name: "userId", value: "\(user.identifier)")
        ])
        let urlRequest = URLRequest(url: requestURL)
        
        return runTask_GetJSON(for: urlRequest, httpMethod: "GET")
    }
    
    public func getUserPostsTask(_ user: User) -> AnyPublisher<Array<Post>, Error> {
        let requestURL = environment.url(endPoint: Endpoint.posts, queryParameters: [
            URLQueryItem(name: "userId", value: "\(user.identifier)")
        ])
        let urlRequest = URLRequest(url: requestURL)
        
        return runTask_GetJSON(for: urlRequest, httpMethod: "GET")
    }
    
    public func getPostsTask(for postId: UInt) -> AnyPublisher<Array<Post>, Error> {
        let requestURL = environment.url(endPoint: Endpoint.posts, queryParameters: [
            URLQueryItem(name: "id", value: "\(postId)")
        ])
        let urlRequest = URLRequest(url: requestURL)
        
        return runTask_GetJSON(for: urlRequest, httpMethod: "GET")
    }
    
    public func getTodosTask(for user: User) -> AnyPublisher<Array<Todo>, Error> {
        let requestURL = environment.url(endPoint: Endpoint.todos, queryParameters: [
            URLQueryItem(name: "userId", value: "\(user.identifier)")
        ])
        let urlRequest = URLRequest(url: requestURL)
        
        return runTask_GetJSON(for: urlRequest, httpMethod: "GET")
    }
    
    public func getComments(for postId: UInt) -> AnyPublisher<Array<Comment>, Error> {
        let requestURL = environment.url(endPoint: Endpoint.comments, queryParameters: [
            URLQueryItem(name: "postId", value: "\(postId)")
        ])
        let urlRequest = URLRequest(url: requestURL)
        
        return runTask_GetJSON(for: urlRequest, httpMethod: "GET")
    }
    
    public func deleteUser(id: UInt) -> AnyPublisher<Void, Error> {
        let requestURL = environment.url(endPoint: Endpoint.comments, queryParameters: []).appendingPathComponent("\(id)")
        var urlRequest = URLRequest(url: requestURL)
        urlRequest.httpMethod = "DELETE"
        
        return session.dataTaskPublisher(for: urlRequest)
        .tryMap { output in
            guard let response = output.response as? HTTPURLResponse else { throw HTTPError.notHttpResponse }
            guard response.statusCode == 200 else { throw HTTPError.statusCode(response.statusCode) }
            
            return Void()
        }
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()
    }
}
