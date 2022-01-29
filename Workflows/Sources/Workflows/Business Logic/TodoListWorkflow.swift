//
//  TodoListViewModel.swift
//  JSONPlaceholder
//
//  Created by William Dunay on 9/25/20.
//  Copyright © 2020 Bill Dunay. All rights reserved.
//

import Combine
import Foundation
import Models

public final class TodoListWorkflow: ObservableObject {
    public struct Dependencies: CombineClientTypeProviding {
        public let combineClient: CombineClientType
        
        public init(combineClient: CombineClientType) {
            self.combineClient = combineClient
        }
    }
    
    @Published public var listOfTodos = [Todo]()
    @Published public private(set) var error: (isShowing: Bool, message: String?) = (isShowing: false, message: nil)
    
    private let user: User
    private let dependencies: Dependencies
    private var cancellables = [AnyCancellable]()
    
    public init(user: User, dependencies: Dependencies) {
        self.user = user
        self.dependencies = dependencies
    }
    
    public func getTodos() {
        dependencies.combineClient.getTodosTask(for: user)
            .sink(receiveCompletion: { (complete) in
                switch complete {
                case .failure(let error):
                    print(error.localizedDescription)
                case .finished:
                    break
                }
            }, receiveValue: { (fetchedTodods) in
                self.listOfTodos = fetchedTodods
            })
            .store(in: &cancellables)
    }
}
