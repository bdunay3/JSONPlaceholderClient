//
//  JSONPlaceholderService.swift
//  JSONPlaceholder
//
//  Created by Bill Dunay on 4/20/20.
//  Copyright © 2020 Bill Dunay. All rights reserved.
//

import Foundation
import os
import Combine

public enum HTTPError: LocalizedError {
    case notHttpResponse
    case statusCode(Int)
    
    public var failureReason: String? {
        switch self {
            
        case .notHttpResponse:
            return "Data returned was not an HTTP protocol response"
            
        case .statusCode(let statusCode):
            return "HTTP Status code: \(statusCode)"
        }
    }
}

public protocol JSONPlachoderApiClientType {
    func getUsersTask() -> AnyPublisher<Array<User>, Error>
    func getAlbumsTask(for user: User) -> AnyPublisher<[Album], Error>
    func getPostsTask(for user: User) -> AnyPublisher<Array<Post>, Error>
    func getPostsTask(for postId: UInt) -> AnyPublisher<Array<Post>, Error>
}

public class JSONPlaceholderApiClient {
    struct Endpoint {
        static let users = "users"
        static let posts = "posts"
        static let albums = "albums"
    }
    
    public let apiClient = URLSession.shared
    // TODO: We want to return a value according to build enviroment var
    public let environment: Environment = .production
    
    public init() {}
}

extension JSONPlaceholderApiClient: JSONPlachoderApiClientType {
    public func getUsersTask() -> AnyPublisher<Array<User>, Error> {
        let requestURL = environment.url(endPoint: Endpoint.users, queryParameters: [])
        let urlRequest = URLRequest(url: requestURL)
        
        return runTask_GetJSON(for: urlRequest)
    }
    
    public func getAlbumsTask(for user: User) -> AnyPublisher<[Album], Error> {
        let requestURL = environment.url(endPoint: Endpoint.albums, queryParameters: [
            URLQueryItem(name: "userId", value: "\(user.identifier)")
        ])
        let urlRequest = URLRequest(url: requestURL)
        
        return runTask_GetJSON(for: urlRequest)
    }
    
    public func getPostsTask(for user: User) -> AnyPublisher<Array<Post>, Error> {
        let requestURL = environment.url(endPoint: Endpoint.posts, queryParameters: [
            URLQueryItem(name: "userId", value: "\(user.identifier)")
        ])
        let urlRequest = URLRequest(url: requestURL)
        
        return runTask_GetJSON(for: urlRequest)
    }
    
    public func getPostsTask(for postId: UInt) -> AnyPublisher<Array<Post>, Error> {
        let requestURL = environment.url(endPoint: Endpoint.posts, queryParameters: [URLQueryItem(name: "id", value: "\(postId)")])
        let urlRequest = URLRequest(url: requestURL)
        
        return runTask_GetJSON(for: urlRequest)
    }
    
    private func runTask_GetJSON<T: Decodable>(for urlRequest: URLRequest) -> AnyPublisher<T, Error> {
        var urlRequest = urlRequest
        urlRequest.httpMethod = "GET"
        
        return apiClient.dataTaskPublisher(for: urlRequest)
        .tryMap { output in
            guard let response = output.response as? HTTPURLResponse else { throw HTTPError.notHttpResponse }
            guard response.statusCode == 200 else { throw HTTPError.statusCode(response.statusCode) }
            
            return output.data
        }
        .decode(type: T.self, decoder: JSONDecoder())
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()
    }
}
