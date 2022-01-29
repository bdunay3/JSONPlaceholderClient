//
//  CommentListViewState.swift
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

public typealias CommentListDependencies = CombineClientTypeProviding

// MARK: - View State

enum CommentListViewState {
    public typealias Publisher = AnyPublisher<CommentListViewState, Never>
    
    case loading(CommentListLoadingModeling)
    case loaded(CommentListLoadedModeling)
    case loadError(CommentListLoadErrorModeling)
}

// MARK: - Loading State

protocol CommentListLoadingModeling {
    func loadComments() -> CommentListViewState.Publisher
}

struct CommentListLoadingModel: CommentListLoadingModeling {
    let post: Post
    let initalCommentsList: [Comment]
    let dependencies: CommentListDependencies
    
    func loadComments() -> CommentListViewState.Publisher {
        dependencies.combineClient.getComments(for: post.identifier)
            .map {
                CommentListViewState.loaded(CommentListLoadedModel(post: post, comments: $0, dependencies: dependencies))
            }
            .catch { (error) -> CommentListViewState.Publisher in
                let model = CommentListLoadErrorModel(post: post, lastKnowCommentList: initalCommentsList, error: error, dependencies: dependencies)
                return Just<CommentListViewState>(.loadError(model))
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}

// MARK: - Loaded State

protocol CommentListLoadedModeling {
    var comments: [Comment] { get }
    
    func refreshComments() -> CommentListViewState.Publisher
}

struct CommentListLoadedModel: CommentListLoadedModeling {
    let post: Post
    let comments: [Comment]
    let dependencies: CommentListDependencies
    
    func refreshComments() -> CommentListViewState.Publisher {
        let loadingStateModel = CommentListLoadingModel(post: post, initalCommentsList: comments, dependencies: dependencies)
        return CurrentValueSubject<CommentListViewState, Never>(.loading(loadingStateModel))
            .merge(with: loadingStateModel.loadComments())
            .eraseToAnyPublisher()
    }
}

// MARK: - Error State

protocol CommentListLoadErrorModeling {
    var lastKnowCommentList: [Comment] { get }
    var error: Error { get }
    
    func cancel() -> CommentListViewState.Publisher
    func retry() -> CommentListViewState.Publisher
}

struct CommentListLoadErrorModel: CommentListLoadErrorModeling {
    let post: Post
    let lastKnowCommentList: [Comment]
    let error: Error
    let dependencies: CommentListDependencies
    
    func cancel() -> CommentListViewState.Publisher {
        Just<CommentListViewState>(.loaded(CommentListLoadedModel(post: post, comments: lastKnowCommentList, dependencies: dependencies)))
            .eraseToAnyPublisher()
    }
    
    func retry() -> CommentListViewState.Publisher {
        let loadingStateModel = CommentListLoadingModel(post: post, initalCommentsList: lastKnowCommentList, dependencies: dependencies)
        return CurrentValueSubject<CommentListViewState, Never>(.loading(loadingStateModel))
            .merge(with: loadingStateModel.loadComments())
            .eraseToAnyPublisher()
    }
}
