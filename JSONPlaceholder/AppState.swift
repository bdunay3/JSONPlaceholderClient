//
//  AppState.swift
//  JSONPlaceholder
//
//  Created by Bill Dunay on 2/15/22.
//  Copyright © 2022 Bill Dunay. All rights reserved.
//

import Combine
import Foundation
import Models
import VSM

enum AppViewState {
    case login(UserLoginModeling)
    case showUser(UserLoggedInModeling)
}

protocol UserLoginModeling {
    var dependencies: Dependencies { get }
    func selected(user: User) -> AnyPublisher<AppViewState, Never>
}

protocol UserLoggedInModeling {
    var loggedInUser: User { get }
    var dependencies: Dependencies { get }
    
    func logout() -> AnyPublisher<AppViewState, Never>
}

struct UserLoginModel: UserLoginModeling {
    let dependencies: Dependencies
    
    func selected(user: User) -> AnyPublisher<AppViewState, Never> {
        Just<AppViewState>(.showUser(UserLoggedInModel(loggedInUser: user, dependencies: dependencies)))
            .eraseToAnyPublisher()
    }
}

struct UserLoggedInModel: UserLoggedInModeling {
    let loggedInUser: User
    let dependencies: Dependencies
    
    func logout() -> AnyPublisher<AppViewState, Never> {
        Just<AppViewState>(.login(UserLoginModel(dependencies: dependencies)))
            .eraseToAnyPublisher()
    }
}
