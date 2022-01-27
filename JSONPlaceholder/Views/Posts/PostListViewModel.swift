//
//  PostListViewModel.swift
//  JSONPlaceholder
//
//  Created by Bill Dunay on 4/30/20.
//  Copyright © 2020 Bill Dunay. All rights reserved.
//

import Foundation
import JSONPlaceholderAPI
import Combine

class PostsListViewModel: ObservableObject {
    let apiClient: JPAClientAsyncType
    let user: User
    
    @Published var posts = [Post]()
    @Published var showErrorMessage = false
    
    private(set) var currentError: Error?
    
    init(with user: User, apiClient: JPAClientAsyncType) {
        self.apiClient = apiClient
        self.user = user
    }
    
    @MainActor
    func getPosts() async {
        do {
            posts = try await apiClient.getPosts(for: user)
        } catch let error {
            currentError = error
            showErrorMessage = true
        }
    }
}
