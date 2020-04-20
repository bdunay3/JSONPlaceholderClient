//
//  JSONPlaceholderService.swift
//  JSONPlaceholder
//
//  Created by Bill Dunay on 4/20/20.
//  Copyright © 2020 Bill Dunay. All rights reserved.
//

import Foundation
import Combine

enum HTTPError: LocalizedError {
    case notHttpResponse
    case statusCode(Int)
    
    var failureReason: String? {
        switch self {
        case .notHttpResponse:
            return "Data returned was not an HTTP protocol response"
            
        case .statusCode(let statusCode):
            return "HTTP Status code: \(statusCode)"
        }
    }
}

protocol PersonServiceType {
    func getUsers(onComplete: @escaping ([User]) -> Void)
    func getUsersTask() -> AnyPublisher<Array<User>, Error>?
}

class PersonService: PersonServiceType {
    struct Constant {
        struct URL {
            static let personListUrl = "https://jsonplaceholder.typicode.com/users"
        }
    }
    let apiClient = URLSession.shared
    
    func getUsers(onComplete: @escaping ([User]) -> Void) {
        guard let requestURL = URL(string: Constant.URL.personListUrl) else {
            // TODO: Do some error reporting
            return
        }
        
        let request = apiClient.dataTask(with: requestURL) { (data, urlResponse, error) in
            // TODO: First convert urlResponse HTTPURLResponse, check HTTP Status code, handle error at that level
            guard error == nil else {
                // TODO: Deal with that error as needed
                return
            }
            
            guard let data = data else {
                // TODO: Report that no HTTP Body was returned
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let people = try decoder.decode(Array<User>.self, from: data)
                DispatchQueue.main.async {
                    onComplete(people)
                }
            } catch {
                print(error)
            }
        }
        
        request.resume()
    }
    
    func getUsersTask() -> AnyPublisher<Array<User>, Error>? {
        guard let requestURL = URL(string: Constant.URL.personListUrl) else {
            // TODO: Do some error reporting
            return nil
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
}
