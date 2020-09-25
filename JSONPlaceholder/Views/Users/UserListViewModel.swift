//
//  UserListPresenter.swift
//  JSONPlaceholder
//
//  Created by Bill Dunay on 4/28/20.
//  Copyright © 2020 Bill Dunay. All rights reserved.
//

import Foundation
import Combine
import JSONPlaceholderAPI

class UserListViewModel: ObservableObject {
    @Published var listOfUsers: [User] = []
    
    let apiClient: JPAClientType
    var cancellationToken: AnyCancellable?
    
    init(apiClient: JPAClientType) {
        self.apiClient = apiClient
    }
    
    func getUsers() {
        self.cancellationToken = apiClient.getUsersTask()
            .sink(receiveCompletion: { _ in
                // TODO Send even to view showing an Alert with error information
            }, receiveValue: { [weak self] (fetchedUsersList) in
                self?.listOfUsers = fetchedUsersList
                self?.cancellationToken = nil
            })
    }
    
    func deleteUser(_ user: User) {
        guard let index = listOfUsers.firstIndex(where: { $0.identifier == user.identifier }) else {
            return
        }
        
        // TODO: Write API call to DELETE user from backend
        listOfUsers.remove(at: index)
    }
    
    func postsViewModel(for user: User) -> PostsListViewModel {
        let viewModel = PostsListViewModel(with: user, apiClient: apiClient)
        
        return viewModel
    }
    
    func albumsViewModel(for user: User) -> AlbumsViewModel {
        let viewModel = AlbumsViewModel(user: user, apiClient: apiClient)
        return viewModel
    }
}
