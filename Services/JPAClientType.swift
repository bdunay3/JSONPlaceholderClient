//
//  JPAClientType.swift
//  JSONPlaceholderAPI
//
//  Created by Bill Dunay on 7/1/21.
//  Copyright © 2021 Bill Dunay. All rights reserved.
//

import Foundation

public protocol JPAClientType {
    func getUsers(onComplete: @escaping (Result<[User], Error>) -> Void)
    func getTodos(for user: User, onComplete: @escaping (Result<[Todo], Error>) -> Void)
}

extension JPAClient: JPAClientType {
    public func getUsers(onComplete: @escaping (Result<[User], Error>) -> Void) {
        let requestURL = environment.url(endPoint: Endpoint.users, queryParameters: [])
        let urlRequest = URLRequest(url: requestURL)
        
        runSessionTask(with: urlRequest, onComplete: onComplete)
    }
    
    public func getTodos(for user: User, onComplete: @escaping (Result<[Todo], Error>) -> Void) {
        let requestURL = environment.url(endPoint: Endpoint.todos, queryParameters: [
            URLQueryItem(name: "userId", value: "\(user.identifier)")
        ])
        let urlRequest = URLRequest(url: requestURL)
        
        runSessionTask(with: urlRequest, onComplete: onComplete)
    }
    
    func runSessionTask<T: Decodable>(with request: URLRequest, onComplete: @escaping ((Result<T, Error>) -> Void)) {
        let task = session.dataTask(with: request) { data, response, error in
            guard let response = response as? HTTPURLResponse else {
                onComplete(.failure(HTTPError.notHttpResponse))
                return
            }
            
            guard response.statusCode == 200 else {
                onComplete(.failure(HTTPError.statusCode(response.statusCode)))
                return
            }
            
            if let error = error {
                onComplete(.failure(error))
                return
            }
            
            guard let data = data else {
                onComplete(.failure(HTTPError.noDataInResponse))
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let decodedData = try decoder.decode(T.self, from: data)
                onComplete(.success(decodedData))
            } catch let error {
                onComplete(.failure(error))
            }
        }
        
        task.resume()
    }
}
