//
//  AppMain.swift
//  JSONPlaceholder
//
//  Created by William Dunay on 9/10/20.
//  Copyright © 2020 Bill Dunay. All rights reserved.
//

import SwiftUI
import JSONPlaceholderAPI

final class CurrentUser: ObservableObject {
    @Published var selectedUser: User?
    
    init(user: User? = nil) {
        self.selectedUser = user
    }
}

@main
struct AppMain: App {
    @ObservedObject var currentUser = CurrentUser()
    
    let apiClient: JPAClient = JPAClient(environment: .production)
    
    var body: some Scene {
        WindowGroup {
            EmptyView()
//            if let selectedUser = currentUser.selectedUser {
//                TabView {
//                    NavigationView {
//                        PostListView(viewModel: PostsListViewModel(with: selectedUser, apiClient: apiClient))
//                    }
//                    .navigationViewStyle(.stack)
//                    .tabItem {
//                        Image(systemName: "text.bubble.fill")
//                        Text("Posts")
//                    }
//
//                    NavigationView {
//                        AlbumsListView(viewModel: AlbumsViewModel(user: selectedUser, apiClient: apiClient))
//                    }
//                    .navigationViewStyle(.stack)
//                    .tabItem {
//                        Image(systemName: "rectangle.stack.fill")
//                        Text("Albums")
//                    }
//
//                    NavigationView {
//                        TodoListView(viewModel: TodoListViewModel(user: selectedUser, apiClient: apiClient))
//                    }
//                    .navigationViewStyle(.stack)
//                    .tabItem {
//                        Image(systemName: "tray.full.fill")
//                        Text("Todo")
//                    }
//                }
//                .edgesIgnoringSafeArea(.top)
//                .environment(\.apiClient, apiClient)
//                .environment(\.asyncApiClient, apiClient)
//
//            } else {
//                NavigationView {
//                    UserListContainerView(viewModel: UserListViewModel(apiClient: apiClient, currentUser: currentUser))
//                }
//                .navigationViewStyle(.stack)
//            }
        }
    }
}
