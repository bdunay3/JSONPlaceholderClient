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
    @AppStorage("currentUserId") var currentUserId: Int = -1
    @ObservedObject var currentUser = CurrentUser()
    
    let apiClient: JPAClientType = JPAClient()
    
    var body: some Scene {
        WindowGroup {
            if let _ = currentUser.selectedUser {
                TabView {
                    NavigationView {
                        PostListView(viewModel: PostsListViewModel(with: currentUser.selectedUser!, apiClient: apiClient))
                    }
                    .tabItem {
                        Image(systemName: "text.bubble.fill")
                        Text("Posts")
                    }
                    
                    NavigationView {
                        AlbumsListView(viewModel: AlbumsViewModel(user: currentUser.selectedUser!, apiClient: apiClient))
                    }
                    .tabItem {
                        Image(systemName: "rectangle.stack.fill")
                        Text("Albums")
                    }
                    
                    NavigationView {
                        TodoListView(viewModel: TodoListViewModel(user: currentUser.selectedUser!, apiClient: apiClient))
                    }
                    .tabItem {
                        Image(systemName: "tray.full.fill")
                        Text("Todo")
                    }
                }
                .edgesIgnoringSafeArea(.top)
                .environment(\.apiClient, apiClient)
                .environmentObject(currentUser)
                
            } else {
                UserListView(viewModel: UserListViewModel(apiClient: AppServices.shared.apiClient), selectedUser: $currentUser.selectedUser)
            }
        }
    }
}
