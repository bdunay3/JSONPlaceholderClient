//
//  TodoListView.swift
//  JSONPlaceholder
//
//  Created by William Dunay on 9/25/20.
//  Copyright © 2020 Bill Dunay. All rights reserved.
//

import SwiftUI
import JSONPlaceholderAPI

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

struct TodoListView: View {
    @StateObject var viewModel: TodoListViewModel
    
    var body: some View {
        List(viewModel.listOfTodos, id: \.identifier) { todo in
            TodoItemView(todo: todo)
        }
        .onAppear {
            self.viewModel.getTodos()
        }
        .navigationBarTitle("Todos")
    }
}

struct TodoListView_Previews: PreviewProvider {
    static var previews: some View {
        let users: [User] = loadObject(from: "User_Single")!
        let todos: [Todo] = loadObject(from: "Todos_SingleUser") ?? []
        
        let viewModel = TodoListViewModel(user: users.first!, apiClient: JPAClient())
        viewModel.listOfTodos = todos
        
        return NavigationView {
            TodoListView(viewModel: viewModel)
        }
    }
}
