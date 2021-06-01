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
    
    let post: Post
    let apiClient: JPAClientType
    
    private(set) var cancellationToken: AnyCancellable?
    
    init(post: Post, apiClient: JPAClientType) {
        self.post = post
        self.apiClient = apiClient
    }
    
    func getComments() {
        print("getting comments...")
        self.cancellationToken = apiClient.getComments(for: post.identifier)
            .sink(receiveCompletion: { (result) in
                switch result {
                case .failure(let error):
                    print(error.localizedDescription)
                case .finished:
                    break
                }
                
            }, receiveValue: { [weak self](latestCommentList) in
                self?.commentList = latestCommentList
            })
    }
}
