//
//  UserListPresenter.swift
//  JSONPlaceholder
//
//  Created by Bill Dunay on 4/28/20.
//  Copyright © 2020 Bill Dunay. All rights reserved.
//

import Foundation
import Combine
import Models
import SwiftUI

public final class UserListWorkflow {
    public struct Dependencies: CombineClientTypeProviding {
        public let combineClient: CombineClientType
        let onSelectedUser: (User) -> Void
        
        public init(combineClient: CombineClientType, onSelectedUser: @escaping (User) -> Void) {
            self.combineClient = combineClient
            self.onSelectedUser = onSelectedUser
        }
    }
    
    @Published public private(set) var viewState: ViewState = .inital
    
    private let dependencies: Dependencies
    private var cancellables = [AnyCancellable]()
    
    public init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
}

extension UserListWorkflow: ElmObservable {
    public typealias Message = UserListAction
    public typealias State = ViewState
    
    public enum ViewState {
        case inital
        case loading
        case loaded([User], AlertableError?)
    }
    
    public enum UserListAction {
        case load
        case selected(User)
        case delete(IndexSet, [User])
    }
    
    public func send(_ message: Message) {
        switch message {
        case .load:
            viewState = .loading
            getUsers()
            
        case .delete(let indexes, let listOfUsers):
            deleteUsers(at: indexes, from: listOfUsers)
            
        case .selected(let user):
            dependencies.onSelectedUser(user)
        }
    }
}

extension UserListWorkflow {
    func getUsers() {
        dependencies.combineClient.getUsersTask()
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
