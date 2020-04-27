//
//  ContentView.swift
//  JSONPlaceholder
//
//  Created by Bill Dunay on 4/20/20.
//  Copyright © 2020 Bill Dunay. All rights reserved.
//

import SwiftUI
import JSONPlaceholderAPI

struct UserList: View {
    let userList: [User]
    
    var body: some View {
        NavigationView {
            List(userList, id: \.self) { user in
                Text(user.name)
            }
        }
        .navigationBarTitle("Users")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        guard let users: [User] = loadList(from: "User_Multiple") else {
            fatalError("Failed to get mock users from local bundle!")
        }
        
        return UserList(userList: users)
    }
}
