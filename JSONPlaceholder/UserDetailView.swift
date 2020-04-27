//
//  UserDetailView.swift
//  JSONPlaceholder
//
//  Created by Bill Dunay on 4/26/20.
//  Copyright © 2020 Bill Dunay. All rights reserved.
//

import SwiftUI
import JSONPlaceholderAPI

struct UserDetailView: View {
    let user: User
    
    var body: some View {
        VStack {
            Text(user.name)
        }
        .padding()
        .navigationBarTitle(Text("Details"), displayMode: .inline)
    }
}

struct UserDetailView_Previews: PreviewProvider {
    static var previews: some View {
        guard let user: User = loadList(from: "User_Single")?.first else {
            fatalError("Couldn't load test user from JSON!")
        }
        
        return UserDetailView(user: user)
    }
}
