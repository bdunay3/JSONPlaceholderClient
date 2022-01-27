//
//  CommentListViewModel.swift
//  JSONPlaceholder
//
//  Created by William Dunay on 10/13/20.
//  Copyright © 2020 Bill Dunay. All rights reserved.
//

import Foundation
import Combine
import JSONPlaceholderAPI

final class CommentListViewModel: ObservableObject {
    @Published var commentList: [Comment] = []
    @Published var showError = false
    
    let post: Post
    let apiClient: JPAClientAsyncType
    
    private(set) var currentError: Error?
    
    init(post: Post, apiClient: JPAClientAsyncType) {
        self.post = post
        self.apiClient = apiClient
    }
    
    func getComments() async {
        do {
            commentList = try await apiClient.getComments(for: post)
        } catch let error {
            showError = true
            currentError = error
        }
    }
}
