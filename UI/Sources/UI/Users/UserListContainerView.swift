//
//  ContentView.swift
//  JSONPlaceholder
//
//  Created by Bill Dunay on 4/20/20.
//  Copyright © 2020 Bill Dunay. All rights reserved.
//

import Workflows
import Combine
import Foundation
import Models
import SwiftUI

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

public struct UserListContainerView: View {
    @ObservedObject
    public var workflow: UserListWorkflow
    
    public var body: some View {
        Group {
            switch workflow.viewState {
            case .inital:
                Text("No users")
            case .loading:
                loadingState()
            case .loaded(let users, let error):
                listView(userList: users, error: error)
            }
        }
        .onAppear {
            workflow.send(.load)
        }
        .navigationBarTitle("Users")
    }
    
    public init(workflow: UserListWorkflow) {
        self.workflow = workflow
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
            workflow.send(.selected($0))
        } onDelete: { indexSet in
            workflow.send(.delete(indexSet, userList))
        }
    }
}

//struct UserListContainerView_Previews: PreviewProvider {
//    private struct CombineClientMock: CombineClientType {
//        func getUsersTask() -> AnyPublisher<Array<User>, Error> {
//            Just<[User]>([])
//                .setFailureType(to: Error.self)
//                .eraseToAnyPublisher()
//        }
//
//        func getAlbumsTask(for user: User) -> AnyPublisher<[Album], Error> {
//            Just<[Album]>([])
//                .setFailureType(to: Error.self)
//                .eraseToAnyPublisher()
//        }
//
//        func getUserPostsTask(_ user: User) -> AnyPublisher<Array<Post>, Error> {
//            Just<[Post]>([])
//                .setFailureType(to: Error.self)
//                .eraseToAnyPublisher()
//        }
//
//        func getPostsTask(for postId: UInt) -> AnyPublisher<Array<Post>, Error> {
//            Just<[Post]>([])
//                .setFailureType(to: Error.self)
//                .eraseToAnyPublisher()
//        }
//
//        func getTodosTask(for user: User) -> AnyPublisher<Array<Todo>, Error> {
//            Just<[Todo]>([])
//                .setFailureType(to: Error.self)
//                .eraseToAnyPublisher()
//        }
//
//        func getComments(for postId: UInt) -> AnyPublisher<Array<Comment>, Error> {
//            Just<[Comment]>([])
//                .setFailureType(to: Error.self)
//                .eraseToAnyPublisher()
//        }
//
//        func deleteUser(id: UInt) -> AnyPublisher<Void, Error> {
//            Just<Void>(Void())
//                .setFailureType(to: Error.self)
//                .eraseToAnyPublisher()
//        }
//    }
//
//    static let users: [User] = [
//        User(
//            identifier: 1,
//            name: "Leanne Graham",
//            username: "Bret",
//            email: "Sincere@april.biz",
//            address: .init(
//               street: "Kulas Light",
//               suite: "Apt. 556",
//               city: "Gwenborough",
//               zipcode: "92998-3874",
//               geo: .init(lat: "-37.3159", lng: "81.1496")
//            ),
//            phone: "1-770-736-8031 x56442",
//            website: "hildegard.org",
//            company: .init(
//               name: "Romaguera-Crona",
//               catchPhrase: "Multi-layered client-server neural-net",
//               bs: "harness real-time e-markets"
//            )
//        ),
//        User(
//            identifier: 2,
//            name: "Ervin Howell",
//            username: "Antonette",
//            email: "Shanna@melissa.tv",
//            address: .init(
//                street: "Victor Plains",
//                suite: "Suite 879",
//                city: "Wisokyburgh",
//                zipcode: "90566-7771",
//                geo: .init(lat: "-43.9509", lng: "-34.4618")
//            ),
//            phone: "010-692-6593 x09125",
//            website: "anastasia.net",
//            company: .init(
//                name: "Deckow-Crist",
//                catchPhrase: "Proactive didactic contingency",
//                bs: "synergize scalable supply-chains"
//            )
//        )
//    ]
//
//    static var dependencies: UserListViewModel.Dependencies {
//        .init(combineClient: CombineClientMock())
//    }
//
//    static var previews: some View {
//        return NavigationView {
//            UserListContainerView(
//                viewModel: UserListViewModel(currentUser: UserManager(),
//                                             dependencies: dependencies))
//        }
//    }
//}
