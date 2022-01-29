//
//  RESTClient.swift
//  
//
//  Created by Bill Dunay on 1/29/22.
//

import Foundation
import Models

public protocol RESTClientType {
    func getUsers(onComplete: @escaping (Result<[User], Error>) -> Void)
    func getTodos(for user: User, onComplete: @escaping (Result<[Todo], Error>) -> Void)
}

public protocol RESTClientTypeProviding {
    var restClient: RESTClientType { get }
}
