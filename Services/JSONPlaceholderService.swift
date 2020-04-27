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
    case malformedURL(String)
    case notHttpResponse
    case statusCode(Int)
    
    public var failureReason: String? {
        switch self {
        case .malformedURL(let urlString):
            return "Couldn't construct a valid instance of `URL` for: \(urlString)"
            
        case .notHttpResponse:
            return "Data returned was not an HTTP protocol response"
            
        case .statusCode(let statusCode):
            return "HTTP Status code: \(statusCode)"
        }
    }
}

public protocol JSONPlachoderServiceType {
    func getUsers(onComplete: @escaping ([User], HTTPError?) -> Void) throws
}

public protocol JSONPlachoderServiceTypeCombine {
    func getUsersTask() throws -> AnyPublisher<Array<User>, Error>?
    func getPostsTask(for user: User) throws -> AnyPublisher<Array<Post>, Error>?
    func getPostsTask(for postId: UInt) throws -> AnyPublisher<Array<Post>, Error>?
}

public class JSONPlaceholderService: JSONPlachoderServiceType {
    struct Constant {
        struct URL {
            static let userListUrl = "https://jsonplaceholder.typicode.com/users"
            static let postsListUrl = "https://jsonplaceholder.typicode.com/posts"
        }
    }
    public let apiClient = URLSession.shared
    
    public func getUsers(onComplete: @escaping ([User], HTTPError?) -> Void) throws {
        guard let requestURL = URL(string: Constant.URL.userListUrl) else {
            throw HTTPError.malformedURL(Constant.URL.userListUrl)
        }
        
        let request = apiClient.dataTask(with: requestURL) { (data, urlResponse, error) in
            // TODO: First convert urlResponse HTTPURLResponse, check HTTP Status code, handle error at that level
            guard let httpResponse = urlResponse as? HTTPURLResponse else {
                onComplete([], HTTPError.notHttpResponse)
                return
            }
            
            guard httpResponse.statusCode == 200 else {
                os_log("HTTP Error: %s", log: .default, type: .error, HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode))
                onComplete([], .statusCode(httpResponse.statusCode))
                return
            }
            
            if error != nil, let errorText = error?.localizedDescription {
                os_log("Transport Error: %s", log: .default, type: .error, errorText)
                onComplete([], .statusCode(httpResponse.statusCode))
                return
            }
            
            guard let data = data else {
                onComplete([], nil)
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let people = try decoder.decode(Array<User>.self, from: data)
                DispatchQueue.main.async {
                    onComplete(people, nil)
                }
            } catch {
                os_log("JSON Parsing Error: %s", log: .default, type: .error, error.localizedDescription)
                onComplete([], nil)
            }
        }
        
        request.resume()
    }
}

extension JSONPlaceholderService: JSONPlachoderServiceTypeCombine {
    public func getUsersTask() throws -> AnyPublisher<Array<User>, Error>? {
        guard let requestURL = URL(string: Constant.URL.userListUrl) else {
            throw HTTPError.malformedURL(Constant.URL.userListUrl)
        }
        
        return apiClient.dataTaskPublisher(for: requestURL)
        .tryMap { output in
            guard let response = output.response as? HTTPURLResponse else { throw HTTPError.notHttpResponse }
            guard response.statusCode == 200 else { throw HTTPError.statusCode(response.statusCode) }
            
            return output.data
        }
        .decode(type: Array<User>.self, decoder: JSONDecoder())
        .eraseToAnyPublisher()
    }
    
    public func getPostsTask(for user: User) throws -> AnyPublisher<Array<Post>, Error>? {
        var urlComponents = URLComponents(string: Constant.URL.postsListUrl)
        urlComponents?.queryItems = [URLQueryItem(name: "userId", value: String(user.identifier))]
        
        guard let requestUrl = urlComponents?.url else {
            throw HTTPError.malformedURL(Constant.URL.postsListUrl)
        }
        
        return apiClient.dataTaskPublisher(for: requestUrl)
        .tryMap { output in
            guard let response = output.response as? HTTPURLResponse else { throw HTTPError.notHttpResponse }
            guard response.statusCode == 200 else { throw HTTPError.statusCode(response.statusCode) }
            
            return output.data
        }
        .decode(type: Array<Post>.self, decoder: JSONDecoder())
        .eraseToAnyPublisher()
    }
    
    public func getPostsTask(for postId: UInt) throws -> AnyPublisher<Array<Post>, Error>? {
        var urlComponents = URLComponents(string: Constant.URL.postsListUrl)
        urlComponents?.queryItems = [URLQueryItem(name: "id", value: "\(postId)")]
        
        guard let requestUrl = urlComponents?.url else {
            throw HTTPError.malformedURL(Constant.URL.postsListUrl)
        }
        
        return apiClient.dataTaskPublisher(for: requestUrl)
        .tryMap { output in
            guard let response = output.response as? HTTPURLResponse else { throw HTTPError.notHttpResponse }
            guard response.statusCode == 200 else { throw HTTPError.statusCode(response.statusCode) }
            
            return output.data
        }
        .decode(type: Array<Post>.self, decoder: JSONDecoder())
        .eraseToAnyPublisher()
    }
}
