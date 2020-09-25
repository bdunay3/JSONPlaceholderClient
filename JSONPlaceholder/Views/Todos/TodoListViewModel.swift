//
//  TodoListViewModel.swift
//  JSONPlaceholder
//
//  Created by William Dunay on 9/25/20.
//  Copyright © 2020 Bill Dunay. All rights reserved.
//

import Combine
import Foundation
import JSONPlaceholderAPI

class TodoListViewModel: ObservableObject {
    @Published var listOfTodos = [Todo]()
    @Published private(set) var error: (isShowing: Bool, message: String?) = (isShowing: false, message: nil)
    
    private let user: User
    private let apiClient: JPAClientType
    private var cancellationToken: AnyCancellable?
    
    init(user: User, apiClient: JPAClientType) {
        self.user = user
        self.apiClient = apiClient
    }
    
    func getTodos() {
        cancellationToken = apiClient.getTodosTask(for: user)
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
    }
}
