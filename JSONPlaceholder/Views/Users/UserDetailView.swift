//
//  UserDetailView.swift
//  JSONPlaceholder
//
//  Created by Bill Dunay on 4/26/20.
//  Copyright © 2020 Bill Dunay. All rights reserved.
//

import SwiftUI
import JSONPlaceholderAPI

struct UserAddressView: View {
    let address: Address
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Address")
                .font(.headline)
                .padding(.bottom, 8)
            
            HStack {
                Image(systemName: "car")
                VStack(alignment: .leading) {
                    HStack{
                        Text(address.street)
                        Text(address.suite)
                    }
                    Text(address.city)
                }
            }
        }
    }
}

struct UserPointOfContactView: View {
    let user: User
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Point of Contact")
                .font(.headline)
            HStack {
                Image(systemName: "envelope")
                Text(user.email)
            }
            HStack {
                Image(systemName: "phone")
                Text(user.phone)
            }
        }
    }
}

struct UserDetailView: View {
    let user: User
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(user.name)
                    .font(.title)
                Text("\(user.company.description)")
                Divider()
                
                UserPointOfContactView(user: user)
                Divider()
                UserAddressView(address: user.address)
                
                Spacer() // Fills in remaining vertical space so item is not centered
            }
            Spacer() // Fills in remaining horizontal space so item is not centered
        }
        .navigationBarTitle(Text("Details"), displayMode: .inline)
        .frame(alignment: .topLeading)
        .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
    }
}

struct UserDetailView_Previews: PreviewProvider {
    static var previews: some View {
        guard let users: [User] = loadObject(from: "User_Single"), let firstUser = users.first else {
            fatalError("Couldn't load test user from JSON!")
        }
        
        return UserDetailView(user: firstUser)
    }
}
