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
    let userList: [User]
    
    var body: some View {
        NavigationView {
            List(userList, id: \.identifier) { user in
                NavigationLink(destination: UserDetailView(user: user)) {
                    UserListRow(user: user)
                }
            }
            .navigationBarTitle("Users")
        }
    }
}

struct UserListView_Previews: PreviewProvider {
    static var previews: some View {
        guard let users: [User] = loadList(from: "User_Multiple") else {
            fatalError("Failed to get mock users from local bundle!")
        }
        
        return UserListView(userList: users)
    }
}
