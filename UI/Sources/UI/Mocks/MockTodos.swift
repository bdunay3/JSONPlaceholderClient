//
//  MockTodos.swift
//  
//
//  Created by Bill Dunay on 2/21/22.
//

import Foundation
import Models

#if DEBUG

extension Todo {
    static var mockTodoList: [Todo] {
        [
            Todo(userId: 0, identifier: 0, title: "Testing First Thing", isCompleted: true),
            Todo(userId: 0, identifier: 1, title: "Testing Second Thing", isCompleted: false)
        ]
    }
}

#endif
