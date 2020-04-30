//
//  ContentView.swift
//  JSONPlaceholder
//
//  Created by Bill Dunay on 4/20/20.
//  Copyright © 2020 Bill Dunay. All rights reserved.
//

import SwiftUI
import JSONPlaceholderAPI

struct UserListRow: View {
    let user: User
    
    @EnvironmentObject var viewModel: UserListViewModel
    @State var isInfoPresented: Bool = false // Creating a state
    @State var isPostsPresented: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(user.name)
            Text(user.email)
                .font(.caption)
        }
        .padding([.vertical], 2)
        .contextMenu {
            Button(action: {
                self.isInfoPresented.toggle()
            }) {
                HStack {
                    Text("Contact Info")
                    Image(systemName: "info.circle")
                }
            }
            .sheet(isPresented: $isInfoPresented) {
                NavigationView {
                    UserDetailView(user: self.user)
                }
            }
            
            Button(action: {
                self.isPostsPresented.toggle()
            }) {
                HStack {
                    Text("Posts")
                    Image(systemName: "message")
                }
            }
            .sheet(isPresented: $isPostsPresented) {
                return NavigationView {
                    PostListView().environmentObject(self.viewModel.postsViewModel(for: self.user))
                }
            }
            
            Button(action: {
                self.isInfoPresented.toggle()
            }) {
                HStack {
                    Text("Delete")
                    Image(systemName: "trash")
                }
            }
            .background(Color.red)
        }
    }
}

struct UserListView: View {
    @EnvironmentObject var viewModel: UserListViewModel
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.listOfUsers, id: \.identifier) { user in
                    NavigationLink(destination: AlbumsListView().environmentObject(self.viewModel.albumsViewModel(for: user))) {
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
    static var previews: some View {
        guard let users: [User] = loadObject(from: "User_Multiple") else {
            fatalError("Failed to get mock users from local bundle!")
        }
        
        let presenter = UserListViewModel(apiClient: JSONPlaceholderApiClient())
        presenter.listOfUsers = users
        
        return UserListView().environmentObject(presenter)
    }
}
