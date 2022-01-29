//
//  PostListViewState.swift
//
//
//  Created by Bill Dunay on 2/16/22.
//

import Combine
import Dependencies
import Foundation
import Models
import VSM

// MARK: Dependencies

public typealias PostListDependencies = CombineClientTypeProviding

// MARK: - View State

enum PostListViewState {
    typealias Publisher = AnyPublisher<PostListViewState, Never>
    
    case loading(PostListLoadingModeling)
    case loaded(PostListLoadedModeling)
    case loadError(PostListLoadErrorModeling)
}

// MARK: - Loading State

protocol PostListLoadingModeling {
    func loadPosts() -> PostListViewState.Publisher
}

struct PostListLoadingModel: PostListLoadingModeling {
    let user: User
    let initalPostList: [Post]
    let dependencies: PostListDependencies
    
    func loadPosts() -> PostListViewState.Publisher {
        dependencies.combineClient.getUserPostsTask(user)
            .map {
                PostListViewState.loaded(PostListLoadedModel(user: user, posts: $0, dependencies: dependencies))
            }
            .catch { (error) -> PostListViewState.Publisher in
                let model = PostListLoadErrorModel(user: user, lastKnowPostList: initalPostList, error: error, dependencies: dependencies)
                return Just<PostListViewState>(.loadError(model))
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}

// MARK: - Loaded State

protocol PostListLoadedModeling {
    var posts: [Post] { get }
    var dependencies: PostListDependencies { get }
    
    func refreshPosts() -> PostListViewState.Publisher
}

struct PostListLoadedModel: PostListLoadedModeling {
    let user: User
    let posts: [Post]
    let dependencies: PostListDependencies
    
    func refreshPosts() -> PostListViewState.Publisher {
        let loadingStateModel = PostListLoadingModel(user: user, initalPostList: posts, dependencies: dependencies)
        return CurrentValueSubject<PostListViewState, Never>(.loading(loadingStateModel))
            .merge(with: loadingStateModel.loadPosts())
            .eraseToAnyPublisher()
    }
}

// MARK: - Error State

protocol PostListLoadErrorModeling {
    var lastKnowPostList: [Post] { get }
    var error: Error { get }
    
    func cancel() -> PostListViewState.Publisher
    func retry() -> PostListViewState.Publisher
}

struct PostListLoadErrorModel: PostListLoadErrorModeling {
    let user: User
    let lastKnowPostList: [Post]
    let error: Error
    let dependencies: PostListDependencies
    
    func cancel() -> PostListViewState.Publisher {
        Just<PostListViewState>(.loaded(PostListLoadedModel(user: user, posts: lastKnowPostList, dependencies: dependencies)))
            .eraseToAnyPublisher()
    }
    
    func retry() -> PostListViewState.Publisher {
        let loadingStateModel = PostListLoadingModel(user: user, initalPostList: lastKnowPostList, dependencies: dependencies)
        return CurrentValueSubject<PostListViewState, Never>(.loading(loadingStateModel))
            .merge(with: loadingStateModel.loadPosts())
            .eraseToAnyPublisher()
    }
}
