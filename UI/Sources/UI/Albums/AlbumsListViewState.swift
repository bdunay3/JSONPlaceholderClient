//
//  AlbumsListViewState.swift
//
//
//  Created by Bill Dunay on 2/17/22.
//

import Combine
import Foundation
import Models
import Dependencies
import VSM

// MARK: Dependencies

public typealias AlbumsListDependencies = CombineClientTypeProviding

// MARK: - View State

enum AlbumsListViewState {
    typealias Publisher = AnyPublisher<AlbumsListViewState, Never>
    
    case loading(AlbumsListLoadingModeling)
    case loaded(AlbumsListLoadedModeling)
    case loadError(AlbumsListLoadErrorModeling)
}

// MARK: - Loading State

protocol AlbumsListLoadingModeling {
    func loadPosts() -> AlbumsListViewState.Publisher
}

struct AlbumsListLoadingModel: AlbumsListLoadingModeling {
    let user: User
    let initalAlbumList: [Album]
    let dependencies: AlbumsListDependencies
    
    func loadPosts() -> AlbumsListViewState.Publisher {
        dependencies.combineClient.getAlbumsTask(for: user)
            .map {
                AlbumsListViewState.loaded(AlbumsListLoadedModel(user: user, albums: $0, dependencies: dependencies))
            }
            .catch { (error) -> AlbumsListViewState.Publisher in
                let model = AlbumsListLoadErrorModel(user: user, lastKnowAlbumList: initalAlbumList, error: error, dependencies: dependencies)
                return Just<AlbumsListViewState>(.loadError(model))
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}

// MARK: - Loaded State

protocol AlbumsListLoadedModeling {
    var albums: [Album] { get }
    var dependencies: AlbumsListDependencies { get }
    
    func refreshAlbums() -> AlbumsListViewState.Publisher
}

struct AlbumsListLoadedModel: AlbumsListLoadedModeling {
    let user: User
    let albums: [Album]
    let dependencies: AlbumsListDependencies
    
    func refreshAlbums() -> AlbumsListViewState.Publisher {
        let loadingStateModel = AlbumsListLoadingModel(user: user, initalAlbumList: albums, dependencies: dependencies)
        return CurrentValueSubject<AlbumsListViewState, Never>(.loading(loadingStateModel))
            .merge(with: loadingStateModel.loadPosts())
            .eraseToAnyPublisher()
    }
}

// MARK: - Error State

protocol AlbumsListLoadErrorModeling {
    var lastKnowAlbumList: [Album] { get }
    var error: Error { get }
    
    func cancel() -> AlbumsListViewState.Publisher
    func retry() -> AlbumsListViewState.Publisher
}

struct AlbumsListLoadErrorModel: AlbumsListLoadErrorModeling {
    let user: User
    let lastKnowAlbumList: [Album]
    let error: Error
    let dependencies: AlbumsListDependencies
    
    func cancel() -> AlbumsListViewState.Publisher {
        Just<AlbumsListViewState>(.loaded(AlbumsListLoadedModel(user: user, albums: lastKnowAlbumList, dependencies: dependencies)))
            .eraseToAnyPublisher()
    }
    
    func retry() -> AlbumsListViewState.Publisher {
        let loadingStateModel = AlbumsListLoadingModel(user: user, initalAlbumList: lastKnowAlbumList, dependencies: dependencies)
        return CurrentValueSubject<AlbumsListViewState, Never>(.loading(loadingStateModel))
            .merge(with: loadingStateModel.loadPosts())
            .eraseToAnyPublisher()
    }
}
