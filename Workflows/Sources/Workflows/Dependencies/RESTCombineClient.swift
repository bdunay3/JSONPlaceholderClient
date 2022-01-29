//
//  RESTCombineClient.swift
//  
//
//  Created by Bill Dunay on 1/29/22.
//

import Combine
import Models

public protocol CombineClientType {
    func getUsersTask() -> AnyPublisher<Array<User>, Error>
    func getAlbumsTask(for user: User) -> AnyPublisher<[Album], Error>
    func getUserPostsTask(_ user: User) -> AnyPublisher<Array<Post>, Error>
    func getPostsTask(for postId: UInt) -> AnyPublisher<Array<Post>, Error>
    func getTodosTask(for user: User) -> AnyPublisher<Array<Todo>, Error>
    func getComments(for postId: UInt) -> AnyPublisher<Array<Comment>, Error>
    
    func deleteUser(id: UInt) -> AnyPublisher<Void, Error>
}

public protocol CombineClientTypeProviding {
    var combineClient: CombineClientType { get }
}
