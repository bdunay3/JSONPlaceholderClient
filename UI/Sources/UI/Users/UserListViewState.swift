//
//  UserListViewState.swift
//
//
//  Created by Bill Dunay on 2/11/22.
//

import Combine
import Dependencies
import Foundation
import Models
import VSM

public struct UserListViewStateDependencies {
    public let combineClient: CombineClientType
    public let onSelect: (User) -> Void
    
    public init(combineClient: CombineClientType, onSelect: @escaping (User) -> Void) {
        self.combineClient = combineClient
        self.onSelect = onSelect
    }
}

public enum UserListViewState {
    case loading(UserListLoadingModeling)
    case loaded(UserListLoadedModeling)
    case loadingError(UserListLoadErrorModeling)
}

public protocol UserListLoadingModeling {
    var currentUserList: [User] { get }
    
    func loadUserList() -> AnyPublisher<UserListViewState, Never>
}

public protocol UserListLoadedModeling {
    var userList: [User] { get }
    
    func reload() -> AnyPublisher<UserListViewState, Never>
    func select(user: User)
    func delete(usersAtIndexes: IndexSet) -> AnyPublisher<UserListViewState, Never>
}

public protocol UserListLoadErrorModeling {
    var userList: [User] { get }
    var error: Error { get }
    
    func reload() -> AnyPublisher<UserListViewState, Never>
    func cancel() -> AnyPublisher<UserListViewState, Never>
}

public struct UserListLoadingModel: UserListLoadingModeling {
    public let currentUserList: [User]
    let dependencies: UserListViewStateDependencies

    public init(currentUserList: [User] = [], dependencies: UserListViewStateDependencies) {
        self.currentUserList = currentUserList
        self.dependencies = dependencies
    }
    
    public func loadUserList() -> AnyPublisher<UserListViewState, Never> {
        dependencies.combineClient.getUsersTask()
            .map {
                let model = UserListLoadedModel(userList: $0, dependencies: dependencies)
                return UserListViewState.loaded(model)
            }
            .catch { (error) -> Just<UserListViewState> in
                let model = UserListLoadErrorModel(userList: [], error: error, dependencies: dependencies)
                return Just(UserListViewState.loadingError(model))
            }
            .eraseToAnyPublisher()
    }
}

public struct UserListLoadedModel: UserListLoadedModeling {
    public let userList: [User]
    let dependencies: UserListViewStateDependencies
    
    public func reload() -> AnyPublisher<UserListViewState, Never> {
        let model = UserListLoadingModel(currentUserList: [], dependencies: dependencies)
        
        return Just<UserListViewState>(.loading(model))
            .merge(with: model.loadUserList())
            .eraseToAnyPublisher()
    }
    
    public func select(user: User) {
        dependencies.onSelect(user)
    }
    
    public func delete(usersAtIndexes: IndexSet) -> AnyPublisher<UserListViewState, Never> {
        let usersToRemove = usersAtIndexes.compactMap { userList[$0] }
        let newUserList = userList.filter { user in
            !usersToRemove.contains(where: { user.id == $0.id })
        }
        
        return Just<UserListViewState>(.loaded(UserListLoadedModel(userList: newUserList, dependencies: dependencies)))
            .eraseToAnyPublisher()
    }
}

public struct UserListLoadErrorModel: UserListLoadErrorModeling {
    public let userList: [User]
    public let error: Error
    let dependencies: UserListViewStateDependencies
    
    public func reload() -> AnyPublisher<UserListViewState, Never> {
        let model = UserListLoadingModel(currentUserList: [], dependencies: dependencies)
        
        return Just<UserListViewState>(.loading(model))
            .merge(with: model.loadUserList())
            .eraseToAnyPublisher()
    }
    
    public func cancel() -> AnyPublisher<UserListViewState, Never> {
        Just<UserListViewState>(.loaded(UserListLoadedModel(userList: userList, dependencies: dependencies)))
            .eraseToAnyPublisher()
    }
}
