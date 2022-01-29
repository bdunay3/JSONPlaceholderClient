//
//  TodoListViewState.swift
//
//
//  Created by Bill Dunay on 2/16/22.
//

import Combine
import Dependencies
import Foundation
import Models
import VSM

// MARK: Dependencies

public typealias TodoListDependencies = CombineClientTypeProviding

// MARK: - View State

enum TodoListViewState {
    typealias Publisher = AnyPublisher<TodoListViewState, Never>
    
    case loading(TodoListLoadingModeling)
    case loaded(TodoListLoadedModeling)
    case loadError(TodoListLoadErrorModeling)
}

// MARK: - Loading State

protocol TodoListLoadingModeling {
    func loadPosts() -> TodoListViewState.Publisher
}

struct TodoListLoadingModel: TodoListLoadingModeling {
    let user: User
    let initalTodoList: [Todo]
    let dependencies: TodoListDependencies
    
    func loadPosts() -> TodoListViewState.Publisher {
        dependencies.combineClient.getTodosTask(for: user)
            .map {
                TodoListViewState.loaded(TodoListLoadedModel(user: user, todos: $0, dependencies: dependencies))
            }
            .catch { (error) -> TodoListViewState.Publisher in
                let model = TodoListLoadErrorModel(user: user, lastKnowTodoList: initalTodoList, error: error, dependencies: dependencies)
                return Just<TodoListViewState>(.loadError(model))
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}

// MARK: - Loaded State

protocol TodoListLoadedModeling {
    var todos: [Todo] { get }
    var dependencies: TodoListDependencies { get }
    
    func refreshTodos() -> TodoListViewState.Publisher
}

struct TodoListLoadedModel: TodoListLoadedModeling {
    let user: User
    let todos: [Todo]
    let dependencies: TodoListDependencies
    
    func refreshTodos() -> TodoListViewState.Publisher {
        let loadingStateModel = TodoListLoadingModel(user: user, initalTodoList: todos, dependencies: dependencies)
        return CurrentValueSubject<TodoListViewState, Never>(.loading(loadingStateModel))
            .merge(with: loadingStateModel.loadPosts())
            .eraseToAnyPublisher()
    }
}

// MARK: - Error State

protocol TodoListLoadErrorModeling {
    var lastKnowTodoList: [Todo] { get }
    var error: Error { get }
    
    func cancel() -> TodoListViewState.Publisher
    func retry() -> TodoListViewState.Publisher
}

struct TodoListLoadErrorModel: TodoListLoadErrorModeling {
    let user: User
    let lastKnowTodoList: [Todo]
    let error: Error
    let dependencies: TodoListDependencies
    
    func cancel() -> TodoListViewState.Publisher {
        Just<TodoListViewState>(.loaded(TodoListLoadedModel(user: user, todos: lastKnowTodoList, dependencies: dependencies)))
            .eraseToAnyPublisher()
    }
    
    func retry() -> TodoListViewState.Publisher {
        let loadingStateModel = TodoListLoadingModel(user: user, initalTodoList: lastKnowTodoList, dependencies: dependencies)
        return CurrentValueSubject<TodoListViewState, Never>(.loading(loadingStateModel))
            .merge(with: loadingStateModel.loadPosts())
            .eraseToAnyPublisher()
    }
}
