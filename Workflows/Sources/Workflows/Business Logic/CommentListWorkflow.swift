//
//  CommentListViewModel.swift
//  JSONPlaceholder
//
//  Created by William Dunay on 10/13/20.
//  Copyright © 2020 Bill Dunay. All rights reserved.
//

import Foundation
import Combine
import Models

public final class CommentListWorkflow: ObservableObject {
    public struct Dependencies: AsyncClientTypeProviding {
        public let asyncClient: AsyncClientType
        
        public init(asyncClient: AsyncClientType) {
            self.asyncClient = asyncClient
        }
    }
    
    @Published public var commentList: [Comment] = []
    @Published public var showError = false
    
    let post: Post
    let dependencies: Dependencies
    
    private(set) var currentError: Error?
    
    public init(post: Post, dependencies: Dependencies) {
        self.post = post
        self.dependencies = dependencies
    }
    
    @MainActor
    public func getComments() async {
        do {
            commentList = try await dependencies.asyncClient.getComments(for: post)
        } catch let error {
            showError = true
            currentError = error
        }
    }
}
