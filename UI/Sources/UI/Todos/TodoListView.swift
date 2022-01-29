//
//  TodoListView.swift
//  JSONPlaceholder
//
//  Created by William Dunay on 9/25/20.
//  Copyright © 2020 Bill Dunay. All rights reserved.
//

import Combine
import Dependencies
import Models
import SwiftUI
import VSM

struct TodoItemView: View {
    let todo: Todo
    
    var body: some View {
        HStack {
            if todo.isCompleted {
                Image(systemName: "checkmark.square")
            }
            else {
                Image(systemName: "square")
            }
            Text(todo.title)
                .strikethrough(todo.isCompleted)
        }
    }
}

public struct TodoListView: View {
    @ObservedObject var stateContainer: StateContainer<TodoListViewState>
    
    public var body: some View {
        Group {
            switch stateContainer.state {
            case .loading(_):
                showLoadingState()
                
            case .loaded(let loadedViewModel):
                showTodos(model: loadedViewModel)
                
            case .loadError(let errorViewModel):
                showLoadErrorState(viewModel: errorViewModel)
            }
        }
        .onAppear {
            if case .loading(let loadingModel) = stateContainer.state {
                stateContainer.observe(loadingModel.loadPosts())
            }
        }
        .navigationBarTitle("Todos")
    }
    
    public init(user: User, dependencies: TodoListDependencies) {
        self.stateContainer = .init(state: .loading(TodoListLoadingModel(user: user, initalTodoList: [], dependencies: dependencies)))
    }
    
    func showLoadingState() -> some View {
        ZStack {
            ProgressView()
                .progressViewStyle(.circular)
        }
    }
    
    func showTodos(model: TodoListLoadedModeling) -> some View {
        List(model.todos, id: \.identifier) { todo in
            TodoItemView(todo: todo)
        }
        .listStyle(.plain)
    }
    
    func showLoadErrorState(viewModel: TodoListLoadErrorModeling) -> some View {
        List(viewModel.lastKnowTodoList, id: \.identifier) { todo in
            TodoItemView(todo: todo)
        }
        .listStyle(.plain)
        .customAlert(displaying: viewModel.error, actions: [
            .init(title: "Cancel", action: { self.stateContainer.observe(viewModel.cancel()) }),
            .init(title: "Retry", action: { self.stateContainer.observe(viewModel.retry()) })
        ])
    }
}

#if DEBUG

fileprivate extension TodoListView {
    init(state: TodoListViewState) {
        self.stateContainer = .init(state: state)
    }
}

struct TodoListView_Previews: PreviewProvider {
    final class MockTodoListLoadingModeling: TodoListLoadingModeling {
        // MARK: - loadPosts
        var loadPostsClosure: (() -> TodoListViewState.Publisher)?
        var loadPostsReturnValue: TodoListViewState.Publisher!
        func loadPosts() -> TodoListViewState.Publisher {
            return loadPostsClosure.map({ $0() }) ?? Empty<TodoListViewState, Never>().eraseToAnyPublisher()
        }
    }
    
    final class MockTodoListLoadedModeling: TodoListLoadedModeling {
        let todos: [Todo]
        let dependencies: TodoListDependencies

        // MARK: - init
        init(todos: [Todo], dependencies: TodoListDependencies) {
            self.todos = todos
            self.dependencies = dependencies
        }


        // MARK: - refreshTodos
        var refreshTodosClosure: (() -> TodoListViewState.Publisher)?
        var refreshTodosReturnValue: TodoListViewState.Publisher!
        func refreshTodos() -> TodoListViewState.Publisher {
            return refreshTodosClosure.map({ $0() }) ?? Empty<TodoListViewState, Never>().eraseToAnyPublisher()
        }
    }
    
    final class MockTodoListLoadErrorModeling: TodoListLoadErrorModeling {
        let lastKnowTodoList: [Todo]
        let error: Error

        // MARK: - init
        init(lastKnowTodoList: [Todo], error: Error) {
            self.lastKnowTodoList = lastKnowTodoList
            self.error = error
        }


        // MARK: - cancel
        var cancelClosure: (() -> TodoListViewState.Publisher)?
        var cancelReturnValue: TodoListViewState.Publisher!
        func cancel() -> TodoListViewState.Publisher {
            return cancelClosure.map({ $0() }) ?? Empty<TodoListViewState, Never>().eraseToAnyPublisher()
        }

        // MARK: - retry
        var retryClosure: (() -> TodoListViewState.Publisher)?
        var retryReturnValue: TodoListViewState.Publisher!
        func retry() -> TodoListViewState.Publisher {
            return retryClosure.map({ $0() }) ?? Empty<TodoListViewState, Never>().eraseToAnyPublisher()
        }
    }
    
    static var previews: some View {
        NavigationView {
            TodoListView(state: .loading(MockTodoListLoadingModeling()))
        }
        .previewDisplayName("Loading")
        
        NavigationView {
            TodoListView(state: .loaded(MockTodoListLoadedModeling(todos: Todo.mockTodoList,
                                                                   dependencies: MockCombineClientTypeProviding())))
        }
        .previewDisplayName("Loaded")
        
        NavigationView {
            TodoListView(state: .loadError(MockTodoListLoadErrorModeling(lastKnowTodoList: Todo.mockTodoList,
                                                                         error: MockError())))
        }
    }
}

#endif
