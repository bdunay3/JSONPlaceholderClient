//
//  AlbumsListView.swift
//  JSONPlaceholder
//
//  Created by Bill Dunay on 4/30/20.
//  Copyright © 2020 Bill Dunay. All rights reserved.
//

import Combine
import Models
import SwiftUI
import VSM
import Dependencies

struct AlbumRowView: View {
    let album: Album
    
    var body: some View {
        Text(album.title)
    }
}

public struct AlbumsListView: View {
    @ObservedObject var stateContainer: StateContainer<AlbumsListViewState>
    
    public var body: some View {
        Group {
            switch stateContainer.state {
            case .loading(_):
                showLoadingState()
                
            case .loaded(let loadedViewModel):
                showAlbums(model: loadedViewModel)
                
            case .loadError(let errorLoadState):
                showLoadErrorState(viewModel: errorLoadState)
            }
        }
        .onAppear {
            if case .loading(let loadingModel) = stateContainer.state {
                stateContainer.observe(loadingModel.loadPosts())
            }
        }
        .navigationBarTitle("Albums")
    }
    
    public init(user: User, dependencies: TodoListDependencies) {
        self.stateContainer = .init(state: .loading(AlbumsListLoadingModel(user: user, initalAlbumList: [], dependencies: dependencies)))
    }
    
    func showLoadingState() -> some View {
        ZStack {
            ProgressView()
                .progressViewStyle(.circular)
        }
    }
    
    func showAlbums(model: AlbumsListLoadedModeling) -> some View {
        List(model.albums, id: \.identifier) { album in
            AlbumRowView(album: album)
        }
        .listStyle(.plain)
    }
    
    func showLoadErrorState(viewModel: AlbumsListLoadErrorModeling) -> some View {
        List(viewModel.lastKnowAlbumList, id: \.identifier) { album in
            AlbumRowView(album: album)
        }
        .listStyle(.plain)
        .customAlert(displaying: viewModel.error, actions: [
            .init(title: "Cancel", action: { self.stateContainer.observe(viewModel.cancel()) }),
            .init(title: "Retry", action: { self.stateContainer.observe(viewModel.retry()) })
        ])
    }
}

#if DEBUG // Wrapped in "#if DEBUG" only because shared mock code is also wrapped in #if DEBUG

fileprivate extension AlbumsListView {
    init(state: AlbumsListViewState) {
        self.stateContainer = .init(state: state)
    }
}

struct AlbumsListView_Previews: PreviewProvider {
    final class MockAlbumsListLoadingModeling: AlbumsListLoadingModeling {
        // MARK: - loadPosts
        var loadPostsClosure: (() -> AlbumsListViewState.Publisher)?
        var loadPostsReturnValue: AlbumsListViewState.Publisher!
        func loadPosts() -> AlbumsListViewState.Publisher {
            return loadPostsClosure.map({ $0() }) ?? Empty<AlbumsListViewState, Never>().eraseToAnyPublisher()
        }
    }
    
    final class MockAlbumsListLoadedModeling: AlbumsListLoadedModeling {
        let albums: [Album]
        let dependencies: AlbumsListDependencies

        // MARK: - init
        init(albums: [Album], dependencies: AlbumsListDependencies) {
            self.albums = albums
            self.dependencies = dependencies
        }


        // MARK: - refreshAlbums
        var refreshAlbumsClosure: (() -> AlbumsListViewState.Publisher)?
        var refreshAlbumsReturnValue: AlbumsListViewState.Publisher!
        func refreshAlbums() -> AlbumsListViewState.Publisher {
            return refreshAlbumsClosure.map({ $0() }) ?? Empty<AlbumsListViewState, Never>().eraseToAnyPublisher()
        }
    }
    
    final class MockAlbumsListLoadErrorModeling: AlbumsListLoadErrorModeling {
        let lastKnowAlbumList: [Album]
        let error: Error

        // MARK: - init
        init(lastKnowAlbumList: [Album], error: Error) {
            self.lastKnowAlbumList = lastKnowAlbumList
            self.error = error
        }


        // MARK: - cancel
        var cancelClosure: (() -> AlbumsListViewState.Publisher)?
        var cancelReturnValue: AlbumsListViewState.Publisher!
        func cancel() -> AlbumsListViewState.Publisher {
            return cancelClosure.map({ $0() }) ?? Empty<AlbumsListViewState, Never>().eraseToAnyPublisher()
        }

        // MARK: - retry
        var retryClosure: (() -> AlbumsListViewState.Publisher)?
        var retryReturnValue: AlbumsListViewState.Publisher!
        func retry() -> AlbumsListViewState.Publisher {
            return retryClosure.map({ $0() }) ?? Empty<AlbumsListViewState, Never>().eraseToAnyPublisher()
        }
    }
    
    static var previews: some View {
        NavigationView {
            AlbumsListView(state: .loading(MockAlbumsListLoadingModeling()))
        }
        .previewDisplayName("Loading")
        
        NavigationView {
            AlbumsListView(state: .loaded(MockAlbumsListLoadedModeling(albums: Album.mockAlbumList,
                                                                       dependencies: MockCombineClientTypeProviding())))
        }
        .previewDisplayName("Loaded")
        
        NavigationView {
            AlbumsListView(state: .loadError(MockAlbumsListLoadErrorModeling(lastKnowAlbumList: Album.mockAlbumList,
                                                                             error: MockError())))
        }
    }
}
#endif
