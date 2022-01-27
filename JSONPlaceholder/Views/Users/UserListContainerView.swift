//
//  ContentView.swift
//  JSONPlaceholder
//
//  Created by Bill Dunay on 4/20/20.
//  Copyright © 2020 Bill Dunay. All rights reserved.
//

import Foundation
import SwiftUI
import JSONPlaceholderAPI

struct UserListRow: View {
    let user: User
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(user.name)
            Text(user.email)
                .font(.caption)
        }
        .padding([.vertical], 2)
    }
}

struct UserListView: View {
    var users: [User]
    
    var onSelected: (User) -> Void
    var onDelete: (IndexSet) -> Void
    
    var body: some View {
        List {
            ForEach(users) { user in
                Button(action: { onSelected(user) }) {
                    UserListRow(user: user)
                }
            }
            .onDelete { (indexSet) in
                onDelete(indexSet)
            }
        }
    }
}

struct UserListContainerView: View {
    @ObservedObject var viewModel: UserListViewModel
    
    var body: some View {
        Group {
            switch viewModel.viewState {
            case .inital:
                Text("No users")
            case .loading:
                loadingState()
            case .loaded(let users, let error):
                listView(userList: users, error: error)
            }
        }
        .onAppear {
            viewModel.send(.load)
        }
        .navigationBarTitle("Users")
    }
    
    @ViewBuilder
    func loadingState() -> some View {
        ZStack {
            ProgressView()
                .progressViewStyle(.circular)
        }
    }
    
    @ViewBuilder
    func listView(userList: [User], error: AlertableError?) -> some View {
        UserListView(users: userList) {
            viewModel.send(.selected($0))
        } onDelete: { indexSet in
            viewModel.send(.delete(indexSet, userList))
        }
    }
}

//struct UserListContainerView_Previews: PreviewProvider {
//    static let users: [User] = loadObject(from: "User_Multiple") ?? []
//    
//    static var previews: some View {
//        let viewModel = UserListViewModel(apiClient: JPAClient())
//        viewModel.listOfUsers = users
//        
//        return NavigationView {
//            UserListContainerView(viewModel: viewModel, selectedUser: .constant(nil))
//        }
//    }
//}
