//
//  TodoListView.swift
//  JSONPlaceholder
//
//  Created by William Dunay on 9/25/20.
//  Copyright © 2020 Bill Dunay. All rights reserved.
//

import Workflows
import Models
import SwiftUI

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
    @ObservedObject
    var workflow: TodoListWorkflow
    
    public var body: some View {
        List(workflow.listOfTodos, id: \.identifier) { todo in
            TodoItemView(todo: todo)
        }
        .onAppear {
            self.workflow.getTodos()
        }
        .navigationBarTitle("Todos")
    }
    
    public init(workflow: TodoListWorkflow) {
        self.workflow = workflow
    }
}

//struct TodoListView_Previews: PreviewProvider {
//    static var previews: some View {
//        let users: [User] = loadObject(from: "User_Single")!
//        let todos: [Todo] = loadObject(from: "Todos_SingleUser") ?? []
//        
//        let workflow = TodoListViewModel(user: users.first!, apiClient: JPAClient())
//        viewModel.listOfTodos = todos
//        
//        return NavigationView {
//            TodoListView(viewModel: viewModel)
//        }
//    }
//}
