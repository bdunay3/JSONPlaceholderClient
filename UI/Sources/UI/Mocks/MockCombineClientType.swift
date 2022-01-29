//
//  MockCombineClientType.swift
//  
//
//  Created by Bill Dunay on 2/21/22.
//

import Combine
import Foundation
import Dependencies
import Models

#if DEBUG

final class MockCombineClientType: CombineClientType {
    // MARK: - getUsersTask
    var getUsersTaskClosure: (() -> AnyPublisher<[User], Error>)?
    var getUsersTaskReturnValue: AnyPublisher<[User], Error>!
    func getUsersTask() -> AnyPublisher<[User], Error> {
        return getUsersTaskClosure.map({ $0() }) ?? Empty<[User], Error>().eraseToAnyPublisher()
    }

    // MARK: - getAlbumsTask
    var getAlbumsTaskForClosure: ((User) -> AnyPublisher<[Album], Error>)?
    var getAlbumsTaskForReceivedUser: User?
    var getAlbumsTaskForReturnValue: AnyPublisher<[Album], Error>!
    func getAlbumsTask(for user: User) -> AnyPublisher<[Album], Error> {
        getAlbumsTaskForReceivedUser = user
        return getAlbumsTaskForClosure.map({ $0(user) }) ?? Empty<[Album], Error>().eraseToAnyPublisher()
    }

    // MARK: - getUserPostsTask
    var getUserPostsTaskClosure: ((User) -> AnyPublisher<[Post], Error>)?
    var getUserPostsTaskReceivedUser: User?
    var getUserPostsTaskReturnValue: AnyPublisher<[Post], Error>!
    func getUserPostsTask(_ user: User) -> AnyPublisher<[Post], Error> {
        getUserPostsTaskReceivedUser = user
        return getUserPostsTaskClosure.map({ $0(user) }) ?? Empty<[Post], Error>().eraseToAnyPublisher()
    }

    // MARK: - getPostsTask
    var getPostsTaskForClosure: ((UInt) -> AnyPublisher<[Post], Error>)?
    var getPostsTaskForReceivedPostId: UInt?
    var getPostsTaskForReturnValue: AnyPublisher<[Post], Error>!
    func getPostsTask(for postId: UInt) -> AnyPublisher<[Post], Error> {
        getPostsTaskForReceivedPostId = postId
        return getPostsTaskForClosure.map({ $0(postId) }) ?? Empty<[Post], Error>().eraseToAnyPublisher()
    }

    // MARK: - getTodosTask
    var getTodosTaskForClosure: ((User) -> AnyPublisher<[Todo], Error>)?
    var getTodosTaskForReceivedUser: User?
    var getTodosTaskForReturnValue: AnyPublisher<[Todo], Error>!
    func getTodosTask(for user: User) -> AnyPublisher<[Todo], Error> {
        getTodosTaskForReceivedUser = user
        return getTodosTaskForClosure.map({ $0(user) }) ?? Empty<[Todo], Error>().eraseToAnyPublisher()
    }

    // MARK: - getComments
    var getCommentsForClosure: ((UInt) -> AnyPublisher<[Comment], Error>)?
    var getCommentsForReceivedPostId: UInt?
    var getCommentsForReturnValue: AnyPublisher<[Comment], Error>!
    func getComments(for postId: UInt) -> AnyPublisher<[Comment], Error> {
        getCommentsForReceivedPostId = postId
        return getCommentsForClosure.map({ $0(postId) }) ?? Empty<[Comment], Error>().eraseToAnyPublisher()
    }

    // MARK: - deleteUser
    var deleteUserIdClosure: ((UInt) -> AnyPublisher<Void, Error>)?
    var deleteUserIdReceivedId: UInt?
    var deleteUserIdReturnValue: AnyPublisher<Void, Error>!
    func deleteUser(id: UInt) -> AnyPublisher<Void, Error> {
        deleteUserIdReceivedId = id
        return deleteUserIdClosure.map({ $0(id) }) ?? Empty<Void, Error>().eraseToAnyPublisher()
    }
}

struct MockCombineClientTypeProviding: CombineClientTypeProviding {
    var combineClient: CombineClientType {
        MockCombineClientType()
    }
}

#endif
