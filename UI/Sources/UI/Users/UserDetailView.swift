//
//  UserDetailView.swift
//  JSONPlaceholder
//
//  Created by Bill Dunay on 4/26/20.
//  Copyright © 2020 Bill Dunay. All rights reserved.
//

import Dependencies
import Models
import SwiftUI

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
        .navigationBarTitle(Text("User Details"), displayMode: .inline)
        .frame(alignment: .topLeading)
        .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
    }
}

struct UserDetailView_Preview: PreviewProvider {
    static var exampleUser: User {
        User(
            identifier: 1,
            name: "Leanne Graham",
            username: "Bret",
            email: "Sincere@april.biz",
            address: .init(
               street: "Kulas Light",
               suite: "Apt. 556",
               city: "Gwenborough",
               zipcode: "92998-3874",
               geo: .init(lat: "-37.3159", lng: "81.1496")
            ),
            phone: "1-770-736-8031 x56442",
            website: "hildegard.org",
            company: .init(
               name: "Romaguera-Crona",
               catchPhrase: "Multi-layered client-server neural-net",
               bs: "harness real-time e-markets"
            )
        )
    }
    
    static var previews: some View {
        NavigationView {
            UserDetailView(user: exampleUser)
        }
    }
}
