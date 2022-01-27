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

public class JPAClient {
    enum Endpoint: String, EndPointType {
        case users = "users"
        case posts = "posts"
        case albums = "albums"
        case todos = "todos"
        case comments = "comments"
    }
    
    public let session = URLSession.shared
    // TODO: We want to return a value according to build enviroment var
    public private(set) var environment: BackendEnvironment
    
    public init(environment: BackendEnvironment = .production) {
        self.environment = environment
    }
}
