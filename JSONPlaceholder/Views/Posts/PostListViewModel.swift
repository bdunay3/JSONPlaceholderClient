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
    let apiClient: JPAClientType
    let user: User
    
    @Published var posts = [Post]()
    private var cancellationToken: AnyCancellable?
    
    init(with user: User, apiClient: JPAClientType) {
        self.apiClient = apiClient
        self.user = user
    }
    
    func getPosts() {
        self.cancellationToken = apiClient.getPostsTask(for: user)
            .sink(receiveCompletion: { complete in
                
                switch complete {
                case .failure(let error):
                    print(error)
                default:
                    break
                }
                
            }, receiveValue: { fetchedPosts in
                self.posts = fetchedPosts
                self.cancellationToken = nil
            })
    }
}
