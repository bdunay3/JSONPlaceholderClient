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
import SwiftUI
import UIKit

class UserListViewModel {
    @Published private(set) var viewState: ViewState = .inital
    var currentUser: CurrentUser
    
    private let apiClient: JPAClientCombineType
    private var cancellables = [AnyCancellable]()
    
    init(apiClient: JPAClientCombineType, currentUser: CurrentUser) {
        self.apiClient = apiClient
        self.currentUser = currentUser
    }
}

extension UserListViewModel: ElmObservable {
    typealias Message = UserListAction
    typealias State = ViewState
    
    enum ViewState {
        case inital
        case loading
        case loaded([User], AlertableError?)
    }
    
    enum UserListAction {
        case load
        case selected(User)
        case delete(IndexSet, [User])
    }
    
    func send(_ message: Message) {
        switch message {
        case .load:
            viewState = .loading
            getUsers()
            
        case .delete(let indexes, let listOfUsers):
            deleteUsers(at: indexes, from: listOfUsers)
            
        case .selected(let user):
            currentUser.selectedUser = user
        }
    }
}

extension UserListViewModel {
    func getUsers() {
        apiClient.getUsersTask()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard case .failure(let error) = completion else { return }
                self?.viewState = .loaded([], AlertableError(error: error, actions: [
                    .init(title: "Cancel", action: { }),
                    .init(title: "Retry", action: { self?.send(.load) })
                ]))
                
            } receiveValue: { [weak self] listOfUsers in
                self?.viewState = .loaded(listOfUsers, nil)
            }
            .store(in: &cancellables)
    }
    
    func deleteUsers(at: IndexSet, from listOfUsers: [User]) {
        
    }
}
