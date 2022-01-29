//
//  MockCombineApi.swift
//  JSONPlaceholderTests
//
//  Created by Bill Dunay on 1/27/22.
//  Copyright © 2022 Bill Dunay. All rights reserved.
//

import Combine
import Foundation
import Models
import Dependencies

final class MockCombineApi: CombineClientType {
    
    init() {}
    
    var getUserPublisher: AnyPublisher<[User], Error>?
    func getUsersTask() -> AnyPublisher<Array<User>, Error> {
        getUserPublisher ?? CurrentValueSubject<[User], Error>([]).eraseToAnyPublisher()
    }
    
    var getAlbumsPublisher: AnyPublisher<[Album], Error>?
    func getAlbumsTask(for user: User) -> AnyPublisher<[Album], Error> {
        getAlbumsPublisher ?? CurrentValueSubject<[Album], Error>([]).eraseToAnyPublisher()
    }
    
    var getUserPosts: AnyPublisher<[Post], Error>?
    func getUserPostsTask(_ user: User) -> AnyPublisher<Array<Post>, Error> {
        getUserPosts ?? CurrentValueSubject<[Post], Error>([]).eraseToAnyPublisher()
    }
    
    var getPostsPublisher: AnyPublisher<[Post], Error>?
    func getPostsTask(for postId: UInt) -> AnyPublisher<Array<Post>, Error> {
        getPostsPublisher ?? CurrentValueSubject<[Post], Error>([]).eraseToAnyPublisher()
    }
    
    var getTodosPublisher: AnyPublisher<Array<Todo>, Error>?
    func getTodosTask(for user: User) -> AnyPublisher<Array<Todo>, Error> {
        getTodosPublisher ?? CurrentValueSubject<[Todo], Error>([]).eraseToAnyPublisher()
    }
    
    var commentsPublisher: AnyPublisher<Array<Comment>, Error>?
    func getComments(for postId: UInt) -> AnyPublisher<Array<Comment>, Error> {
        commentsPublisher ?? CurrentValueSubject<[Comment], Error>([]).eraseToAnyPublisher()
    }
    
    var deleteUserPublisher: AnyPublisher<Void, Error>?
    func deleteUser(id: UInt) -> AnyPublisher<Void, Error> {
        deleteUserPublisher ?? CurrentValueSubject<Void, Error>(Void()).eraseToAnyPublisher()
    }
}
