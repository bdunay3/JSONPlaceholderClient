//
//  AppMain.swift
//  JSONPlaceholder
//
//  Created by William Dunay on 9/10/20.
//  Copyright © 2020 Bill Dunay. All rights reserved.
//

import Dependencies
import Models
import RESTClient
import SwiftUI
import UI
import VSM

@main
struct AppMain: App {
    @SceneBuilder var body: some Scene {
        WindowGroup {
            LoginManagementView(state: .login(UserLoginModel(dependencies: Dependencies(environment: .production))))
        }
    }
}

struct LoginManagementView: View {
    @ObservedObject var stateContainer: StateContainer<AppViewState>
    
    var body: some View {
        Group {
            switch stateContainer.state {
            case .login(let loginViewModel):
                showUserListView(model: loginViewModel)
                
            case .showUser(let loggedInUserModel):
                showLoggedInUserViews(model: loggedInUserModel)
            }
        }
    }
    
    init(state: AppViewState) {
        self.stateContainer = .init(state: state)
    }
    
    func showUserListView(model: UserLoginModeling) -> some View {
        NavigationView {
            UserListContainerView(dependencies: .init(combineClient: model.dependencies.restClient, onSelect: {
                self.stateContainer.observe(model.selected(user: $0))
            }))
        }
        .navigationViewStyle(.stack)
    }
    
    func showLoggedInUserViews(model: UserLoggedInModeling) -> some View {
        TabView {
            tabItem(title: "Posts", icon: "text.bubble.fill") {
                PostListView(user: model.loggedInUser, dependencies: model.dependencies)
                    .applyLogout(from: model, using: self.stateContainer)
            }
            
            tabItem(title: "Albums", icon: "rectangle.stack.fill") {
                AlbumsListView(user: model.loggedInUser, dependencies: model.dependencies)
                    .applyLogout(from: model, using: self.stateContainer)
            }
            
            tabItem(title: "Todo", icon: "tray.full.fill") {
                TodoListView(user: model.loggedInUser, dependencies: model.dependencies)
                    .applyLogout(from: model, using: self.stateContainer)
            }
        }
        .edgesIgnoringSafeArea(.top)
    }
    
    func tabItem<Content: View>(title: String, icon: String, presenting tabContents: () -> Content) -> some View {
        NavigationView {
            tabContents()
        }
        .navigationViewStyle(.stack)
        .tabItem {
            Label(title, systemImage: icon)
        }
    }
}

private extension View {
    func applyLogout(from model: UserLoggedInModeling, using stateContainer: StateContainer<AppViewState>) -> some View {
        self.toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    stateContainer.observe(model.logout())
                }) {
                    Image(systemName: "arrow.backward.square")
                }
            }
        }
    }
}
