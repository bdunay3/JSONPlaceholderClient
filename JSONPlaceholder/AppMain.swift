//
//  AppMain.swift
//  JSONPlaceholder
//
//  Created by William Dunay on 9/10/20.
//  Copyright © 2020 Bill Dunay. All rights reserved.
//

import Models
import RESTClient
import SwiftUI
import Workflows
import UI

@main
struct AppMain: App {
    @StateObject var dependencies = Dependencies(environment: .production)
    @StateObject var appWorkflow = AppWorkflow()
    
    var body: some Scene {
        WindowGroup {
            switch appWorkflow.viewState {
                case .showUserList:
                    userListView()
                    
                case .showUser(let user):
                    loggedInUserTabView(for: user)
            }
        }
    }
    
    @ViewBuilder
    func userListView() -> some View {
        NavigationView {
            UserListContainerView(workflow: UserListWorkflow(dependencies: .init(combineClient: dependencies.restClient) {
                self.appWorkflow.send(.selectedUser($0))
            }))
        }
        .navigationViewStyle(.stack)
    }
    
    func loggedInUserTabView(for selectedUser: User) -> some View {
        TabView {
            NavigationView {
                PostListView(
                    workflow: PostsListWorkflow(with: selectedUser, dependencies: .init(asyncClient: dependencies.restClient))
                )
            }
            .navigationViewStyle(.stack)
            .tabItem {
                Image(systemName: "text.bubble.fill")
                Text("Posts")
            }
            
            NavigationView {
                AlbumsListView(
                    workflow: AlbumsWorkflow(user: selectedUser, dependencies: .init(combineClient: dependencies.restClient))
                )
            }
            .navigationViewStyle(.stack)
            .tabItem {
                Image(systemName: "rectangle.stack.fill")
                Text("Albums")
            }
            
            NavigationView {
                TodoListView(workflow: TodoListWorkflow(user: selectedUser, dependencies: .init(combineClient: dependencies.restClient)))
            }
            .navigationViewStyle(.stack)
            .tabItem {
                Image(systemName: "tray.full.fill")
                Text("Todo")
            }
        }
        .edgesIgnoringSafeArea(.top)
    }
}
