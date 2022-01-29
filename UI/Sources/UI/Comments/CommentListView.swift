//
//  CommentListView.swift
//  JSONPlaceholder
//
//  Created by William Dunay on 10/13/20.
//  Copyright © 2020 Bill Dunay. All rights reserved.
//

import Combine
import Dependencies
import Models
import SwiftUI
import VSM

struct CommentListItem: View {
    let comment: Comment
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(comment.name)
                .bold()
            Text(comment.email)
                .foregroundColor(.blue)
            Text(comment.body)
                .padding(.top, 8)
        }
    }
}

struct CommentListView: View {
    @ObservedObject var stateContainer: StateContainer<CommentListViewState>
    
    var body: some View {
        Group {
            switch stateContainer.state {
            case .loading(_):
                showLoadingState()
                
            case .loaded(let loadedViewModel):
                showLoadedComments(model: loadedViewModel)
                
            case .loadError(let errorStateViewModel):
                errorListView(model: errorStateViewModel)
            }
        }
        .onAppear {
            if case .loading(let loadingModel) = stateContainer.state {
                stateContainer.observe(loadingModel.loadComments())
            }
        }
        .navigationBarTitle("Comments")
    }
    
    init(post: Post, depdendencies: CommentListDependencies) {
        self.stateContainer = .init(state: .loading(CommentListLoadingModel(post: post,
                                                                            initalCommentsList: [],
                                                                            dependencies: depdendencies)))
    }
    
    func showLoadingState() -> some View {
        ZStack {
            ProgressView()
                .progressViewStyle(.circular)
        }
    }
    
    func showLoadedComments(model: CommentListLoadedModeling) -> some View {
        List {
            ForEach(model.comments, id: \.identifier) { comment in
                CommentListItem(comment: comment)
            }
        }
        .listStyle(.plain)
    }
    
    func errorListView(model: CommentListLoadErrorModeling) -> some View {
        List {
            ForEach(model.lastKnowCommentList, id: \.identifier) { comment in
                CommentListItem(comment: comment)
            }
        }
        .listStyle(.plain)
        .customAlert(displaying: model.error, actions: [
            .init(title: "Cancel", action: { self.stateContainer.observe(model.cancel()) }),
            .init(title: "Retry", action: { self.stateContainer.observe(model.retry()) })
        ])
    }
}

#if DEBUG
fileprivate extension CommentListView {
    init(state: CommentListViewState) {
        self.stateContainer = .init(state: state)
    }
}

struct CommentListView_Previews: PreviewProvider {
    final class MockCommentListLoadingModeling: CommentListLoadingModeling {
        // MARK: - loadComments
        var loadCommentsClosure: (() -> CommentListViewState.Publisher)?
        var loadCommentsReturnValue: CommentListViewState.Publisher!
        func loadComments() -> CommentListViewState.Publisher {
            return loadCommentsClosure.map({ $0() }) ?? Empty<CommentListViewState, Never>().eraseToAnyPublisher()
        }
    }
    
    final class MockCommentListLoadedModeling: CommentListLoadedModeling {
        let comments: [Comment]

        // MARK: - init
        init(comments: [Comment]) {
            self.comments = comments
        }


        // MARK: - refreshComments
        var refreshCommentsClosure: (() -> CommentListViewState.Publisher)?
        var refreshCommentsReturnValue: CommentListViewState.Publisher!
        func refreshComments() -> CommentListViewState.Publisher {
            return refreshCommentsClosure.map({ $0() }) ?? Empty<CommentListViewState, Never>().eraseToAnyPublisher()
        }
    }
    
    final class MockCommentListLoadErrorModeling: CommentListLoadErrorModeling {
        let lastKnowCommentList: [Comment]
        let error: Error

        // MARK: - init
        init(lastKnowCommentList: [Comment], error: Error) {
            self.lastKnowCommentList = lastKnowCommentList
            self.error = error
        }


        // MARK: - cancel
        var cancelClosure: (() -> CommentListViewState.Publisher)?
        var cancelReturnValue: CommentListViewState.Publisher!
        func cancel() -> CommentListViewState.Publisher {
            return cancelClosure.map({ $0() }) ?? Empty<CommentListViewState, Never>().eraseToAnyPublisher()
        }

        // MARK: - retry
        var retryClosure: (() -> CommentListViewState.Publisher)?
        var retryReturnValue: CommentListViewState.Publisher!
        func retry() -> CommentListViewState.Publisher {
            return retryClosure.map({ $0() }) ?? Empty<CommentListViewState, Never>().eraseToAnyPublisher()
        }
    }
    
    static var previews: some View {
        NavigationView {
            CommentListView(state: .loading(MockCommentListLoadingModeling()))
        }
        .previewDisplayName("Loading")
        
        NavigationView {
            CommentListView(state: .loaded(MockCommentListLoadedModeling(comments: Comment.mockCommentList)))
        }
        .previewDisplayName("Loaded")
        
        NavigationView {
            CommentListView(state: .loadError(MockCommentListLoadErrorModeling(lastKnowCommentList: Comment.mockCommentList,
                                                                               error: MockError())))
        }
    }
}
#endif
