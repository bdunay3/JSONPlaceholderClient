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
    @StateObject var viewModel: UserListViewModel    
    @Binding var selectedUser: User?
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.listOfUsers) { user in
                    Button(action: { self.selectedUser = user }) {
                        UserListRow(user: user)
                    }
                }
                .onDelete { (indexSet) in
                    for index in indexSet {
                        if let userToDelete = self.viewModel.listOfUsers[safe: index] {
                            self.viewModel.deleteUser(userToDelete)
                        }
                    }
                }
            }
            .navigationBarTitle("Users")
        }
        .onAppear {
            self.viewModel.getUsers()
        }
    }
}

struct UserListView_Previews: PreviewProvider {
    static let users: [User] = loadObject(from: "User_Multiple") ?? []
    
    static var previews: some View {
        let viewModel = UserListViewModel(apiClient: JPAClient())
        viewModel.listOfUsers = users
        
        return UserListView(viewModel: viewModel, selectedUser: .constant(nil))
    }
}
