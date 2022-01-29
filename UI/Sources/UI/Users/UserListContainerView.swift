//
//  ContentView.swift
//  JSONPlaceholder
//
//  Created by Bill Dunay on 4/20/20.
//  Copyright © 2020 Bill Dunay. All rights reserved.
//

import Dependencies
import Combine
import Foundation
import Models
import SwiftUI
import VSM

struct UserListRow: View {
    let user: User
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(user.name)
                Text(user.email)
                    .font(.caption)
            }
        }
        .padding([.vertical], 2)
    }
}

struct UserListView: View {
    var users: [User]
    
    var onSelected: ((User) -> Void)?
    var onDelete: ((IndexSet) -> Void)?
    
    @State var presentInfo = false
    
    var body: some View {
        List {
            ForEach(users) { user in
                UserListRow(user: user)
                    .onTapGesture {
                        self.onSelected?(user)
                    }
                    .onLongPressGesture(minimumDuration: 1, perform: {
                        presentInfo.toggle()
                    })
                    .sheet(isPresented: $presentInfo) {
                        NavigationView {
                            UserDetailView(user: user)
                        }
                        .navigationViewStyle(.stack)
                    }
            }
            .onDelete { (indexSet) in
                onDelete?(indexSet)
            }
        }
        .listStyle(.grouped)
    }
    
    init(users: [User], onSelected: ((User) -> Void)? = nil, onDelete: ((IndexSet) -> Void)? = nil) {
        self.users = users
        self.onSelected = onSelected
        self.onDelete = onDelete
    }
}

public struct UserListContainerView: View {
    @ObservedObject var stateContainer: StateContainer<UserListViewState>

    public var body: some View {
        Group {
            switch stateContainer.state {
            case .loading(_):
                loadingState()
                
            case .loaded(let loadedViewModel):
                listView(model: loadedViewModel)
                
            case .loadingError(let loadErrorViewModel):
                errorListView(model: loadErrorViewModel)
            }
        }
        .onAppear {
            if case .loading(let loadingModel) = stateContainer.state {
                stateContainer.observe(loadingModel.loadUserList())
            }
        }
        .navigationBarTitle("Users")
    }

    public init(dependencies: UserListViewStateDependencies) {
        self.stateContainer = StateContainer<UserListViewState>(state: .loading(UserListLoadingModel(dependencies: dependencies)))
    }

    func loadingState() -> some View {
        ZStack {
            ProgressView()
                .progressViewStyle(.circular)
        }
    }

    @ViewBuilder
    func listView(model: UserListLoadedModeling) -> some View {
        UserListView(users: model.userList) {
            model.select(user: $0)
        } onDelete: {
            self.stateContainer.observe(model.delete(usersAtIndexes: $0))
        }
    }
    
    func errorListView(model: UserListLoadErrorModeling) -> some View {
        UserListView(users: model.userList)
        .customAlert(displaying: model.error, actions: [
            .init(title: "Cancel", action: { self.stateContainer.observe(model.cancel()) }),
            .init(title: "Retry", action: { self.stateContainer.observe(model.reload()) })
        ])
    }
}

#if DEBUG // Wrapped in "#if DEBUG" only because shared mock code is also wrapped in #if DEBUG

fileprivate extension UserListContainerView {
    init(state: UserListViewState) {
        self.stateContainer = StateContainer<UserListViewState>(state: state)
    }
}

struct UserListContainerView_Previews: PreviewProvider {
    final class MockUserListLoadErrorModeling: UserListLoadErrorModeling {
        let userList: [User]
        let error: Error

        // MARK: - init
        public init(userList: [User], error: Error) {
            self.userList = userList
            self.error = error
        }


        // MARK: - reload
        var reloadClosure: (() -> AnyPublisher<UserListViewState, Never>)?
        var reloadReturnValue: AnyPublisher<UserListViewState, Never>!
        func reload() -> AnyPublisher<UserListViewState, Never> {
            return reloadClosure.map({ $0() }) ?? Empty<UserListViewState, Never>().eraseToAnyPublisher()
        }

        // MARK: - cancel
        var cancelClosure: (() -> AnyPublisher<UserListViewState, Never>)?
        var cancelReturnValue: AnyPublisher<UserListViewState, Never>!
        func cancel() -> AnyPublisher<UserListViewState, Never> {
            return cancelClosure.map({ $0() }) ?? Empty<UserListViewState, Never>().eraseToAnyPublisher()
        }
    }

    final class MockUserListLoadedModeling: UserListLoadedModeling {
        let userList: [User]

        // MARK: - init
        public init(userList: [User]) {
            self.userList = userList
        }


        // MARK: - reload
        var reloadClosure: (() -> AnyPublisher<UserListViewState, Never>)?
        var reloadReturnValue: AnyPublisher<UserListViewState, Never>!
        func reload() -> AnyPublisher<UserListViewState, Never> {
            return reloadClosure.map({ $0() }) ?? Empty<UserListViewState, Never>().eraseToAnyPublisher()
        }

        // MARK: - select
        var selectUserClosure: ((User) -> Void)?
        var selectUserReceivedUser: User?
        func select(user: User) {
            selectUserReceivedUser = user
            selectUserClosure?(user)
        }

        // MARK: - delete
        var deleteUsersAtIndexesClosure: ((IndexSet) -> AnyPublisher<UserListViewState, Never>)?
        var deleteUsersAtIndexesReceivedUsersAtIndexes: IndexSet?
        var deleteUsersAtIndexesReturnValue: AnyPublisher<UserListViewState, Never>!
        func delete(usersAtIndexes: IndexSet) -> AnyPublisher<UserListViewState, Never> {
            deleteUsersAtIndexesReceivedUsersAtIndexes = usersAtIndexes
            return deleteUsersAtIndexesClosure.map({ $0(usersAtIndexes) }) ?? Empty<UserListViewState, Never>().eraseToAnyPublisher()
        }
    }

    final class MockUserListLoadingModeling: UserListLoadingModeling {
        let currentUserList: [User]

        // MARK: - init
        public init(currentUserList: [User]) {
            self.currentUserList = currentUserList
        }


        // MARK: - loadUserList
        var loadUserListClosure: (() -> AnyPublisher<UserListViewState, Never>)?
        var loadUserListReturnValue: AnyPublisher<UserListViewState, Never>!
        func loadUserList() -> AnyPublisher<UserListViewState, Never> {
            return loadUserListClosure.map({ $0() }) ?? Empty<UserListViewState, Never>().eraseToAnyPublisher()
        }
    }

    static var previews: some View {
        NavigationView {
            UserListContainerView(state: .loading(MockUserListLoadingModeling(currentUserList: [])))
        }
        .previewDisplayName("Loading")

        NavigationView {
            UserListContainerView(state: .loaded(MockUserListLoadedModeling(userList: User.mockUserList)))
        }.previewDisplayName("Loaded")

        NavigationView {
            UserListContainerView(state: .loadingError(MockUserListLoadErrorModeling(userList: User.mockUserList, 
                                                                                     error: MockError())))
        }.previewDisplayName("Loaded w/ Error")
    }
}
#endif
