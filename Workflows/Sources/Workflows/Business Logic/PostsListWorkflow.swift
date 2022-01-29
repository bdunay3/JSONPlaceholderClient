//
//  PostListViewModel.swift
//  JSONPlaceholder
//
//  Created by Bill Dunay on 4/30/20.
//  Copyright © 2020 Bill Dunay. All rights reserved.
//

import Combine
import Foundation
import Models

public final class PostsListWorkflow: ObservableObject {
    public struct Dependencies: AsyncClientTypeProviding {
        public let asyncClient: AsyncClientType
        
        public init(asyncClient: AsyncClientType) {
            self.asyncClient = asyncClient
        }
    }
    
    public let dependencies: Dependencies
    public let user: User
    
    @Published public var posts = [Post]()
    @Published public var showErrorMessage = false
    
    public private(set) var currentError: Error?
    
    public init(with user: User, dependencies: Dependencies) {
        self.user = user
        self.dependencies = dependencies
    }
    
    @MainActor
    public func getPosts() async {
        do {
            posts = try await dependencies.asyncClient.getPosts(for: user)
        } catch let error {
            currentError = error
            showErrorMessage = true
        }
    }
}
