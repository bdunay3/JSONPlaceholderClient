//
//  MockUsers.swift
//  
//
//  Created by Bill Dunay on 2/21/22.
//

import Foundation
import Models

#if DEBUG

extension User {
    static var mockSingleUser: User {
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
    
    static var mockUserList: [User] {
        [
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
            ),
            User(
                identifier: 2,
                name: "Ervin Howell",
                username: "Antonette",
                email: "Shanna@melissa.tv",
                address: .init(
                    street: "Victor Plains",
                    suite: "Suite 879",
                    city: "Wisokyburgh",
                    zipcode: "90566-7771",
                    geo: .init(lat: "-43.9509", lng: "-34.4618")
                ),
                phone: "010-692-6593 x09125",
                website: "anastasia.net",
                company: .init(
                    name: "Deckow-Crist",
                    catchPhrase: "Proactive didactic contingency",
                    bs: "synergize scalable supply-chains"
                )
            )
        ]
    }
}

#endif
