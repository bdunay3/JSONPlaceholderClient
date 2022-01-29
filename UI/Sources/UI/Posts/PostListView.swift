//
//  PostListView.swift
//  JSONPlaceholder
//
//  Created by Bill Dunay on 4/29/20.
//  Copyright © 2020 Bill Dunay. All rights reserved.
//

import Combine
import Dependencies
import Models
import SwiftUI
import VSM

struct PostItemView: View {
    let post: Post
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(post.title)
                .font(.headline)
                .padding(.bottom, 6)
            Text(post.body)
                .multilineTextAlignment(.leading)
                .font(.body)
                .lineLimit(nil)
        }
        .padding(.bottom, 10)
    }
}

public struct PostListView: View {
    @ObservedObject var stateContainer: StateContainer<PostListViewState>
    
    public var body: some View {
        Group {
            switch stateContainer.state {
            case .loading(_):
                showLoadingState()
                
            case .loaded(let loadedViewModel):
                showPostsList(viewModel: loadedViewModel)
                
            case .loadError(let errorViewModel):
                errorListView(viewModel: errorViewModel)
            }
        }
        .onAppear {
            if case .loading(let loadingModel) = stateContainer.state {
                stateContainer.observe(loadingModel.loadPosts())
            }
        }
        .navigationBarTitle("Posts")
    }
    
    public init(user: User, dependencies: PostListDependencies) {
        self.stateContainer = .init(state: .loading(PostListLoadingModel(user: user,
                                                                         initalPostList: [],
                                                                         dependencies: dependencies)))
    }
    
    func showLoadingState() -> some View {
        ZStack {
            ProgressView()
                .progressViewStyle(.circular)
        }
    }
    
    func showPostsList(viewModel: PostListLoadedModeling) -> some View {
        List {
            ForEach(viewModel.posts, id: \.identifier) { post in
                NavigationLink {
                    CommentListView(post: post, depdendencies: viewModel.dependencies)
                } label: {
                    PostItemView(post: post)
                }
            }
        }
        .listStyle(.plain)
    }
    
    func errorListView(viewModel: PostListLoadErrorModeling) -> some View {
        List {
            ForEach(viewModel.lastKnowPostList, id: \.identifier) {
                PostItemView(post: $0)
            }
        }
        .listStyle(.plain)
        .customAlert(displaying: viewModel.error, actions: [
            .init(title: "Cancel", action: { self.stateContainer.observe(viewModel.cancel()) }),
            .init(title: "Retry", action: { self.stateContainer.observe(viewModel.retry()) })
        ])
    }
}

#if DEBUG
fileprivate extension PostListView {
    init(state: PostListViewState) {
        self.stateContainer = .init(state: state)
    }
}

struct PostListView_Previews: PreviewProvider {
    final class MockPostListLoadingModeling: PostListLoadingModeling {
        // MARK: - loadPosts
        var loadPostsClosure: (() -> PostListViewState.Publisher)?
        var loadPostsReturnValue: PostListViewState.Publisher!
        func loadPosts() -> PostListViewState.Publisher {
            return loadPostsClosure.map({ $0() }) ?? Empty<PostListViewState, Never>().eraseToAnyPublisher()
        }
    }
    
    final class MockPostListLoadedModeling: PostListLoadedModeling {
        let posts: [Post]
        let dependencies: PostListDependencies

        // MARK: - init
        init(posts: [Post], dependencies: PostListDependencies) {
            self.posts = posts
            self.dependencies = dependencies
        }


        // MARK: - refreshPosts
        var refreshPostsClosure: (() -> PostListViewState.Publisher)?
        var refreshPostsReturnValue: PostListViewState.Publisher!
        func refreshPosts() -> PostListViewState.Publisher {
            return refreshPostsClosure.map({ $0() }) ?? Empty<PostListViewState, Never>().eraseToAnyPublisher()
        }
    }
    
    final class MockPostListLoadErrorModeling: PostListLoadErrorModeling {
        let lastKnowPostList: [Post]
        let error: Error

        // MARK: - init
        init(lastKnowPostList: [Post], error: Error) {
            self.lastKnowPostList = lastKnowPostList
            self.error = error
        }


        // MARK: - cancel
        var cancelClosure: (() -> PostListViewState.Publisher)?
        var cancelReturnValue: PostListViewState.Publisher!
        func cancel() -> PostListViewState.Publisher {
            return cancelClosure.map({ $0() }) ?? Empty<PostListViewState, Never>().eraseToAnyPublisher()
        }

        // MARK: - retry
        var retryClosure: (() -> PostListViewState.Publisher)?
        var retryReturnValue: PostListViewState.Publisher!
        func retry() -> PostListViewState.Publisher {
            return retryClosure.map({ $0() }) ?? Empty<PostListViewState, Never>().eraseToAnyPublisher()
        }
    }
    
    static var previews: some View {
        NavigationView {
            PostListView(state: .loading(MockPostListLoadingModeling()))
        }
        .previewDisplayName("Loading")
        
        NavigationView {
            PostListView(state: .loaded(MockPostListLoadedModeling(posts: Post.mockPostList,
                                                                   dependencies: MockCombineClientTypeProviding())))
        }
        .previewDisplayName("Loaded")
        
        NavigationView {
            PostListView(state: .loadError(MockPostListLoadErrorModeling(lastKnowPostList: Post.mockPostList,
                                                                         error: MockError())))
        }
    }
}
#endif
