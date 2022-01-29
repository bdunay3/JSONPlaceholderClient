//
//  RESTCombineClient.swift
//
//
//  Created by Bill Dunay on 1/29/22.
//

import Combine
import Models

public protocol CombineClientType {
    func getUsersTask() -> AnyPublisher<[User], Error>
    func getAlbumsTask(for user: User) -> AnyPublisher<[Album], Error>
    func getUserPostsTask(_ user: User) -> AnyPublisher<[Post], Error>
    func getPostsTask(for postId: UInt) -> AnyPublisher<[Post], Error>
    func getTodosTask(for user: User) -> AnyPublisher<[Todo], Error>
    func getComments(for postId: UInt) -> AnyPublisher<[Comment], Error>
    
    func deleteUser(id: UInt) -> AnyPublisher<Void, Error>
}

public protocol CombineClientTypeProviding {
    var combineClient: CombineClientType { get }
}
