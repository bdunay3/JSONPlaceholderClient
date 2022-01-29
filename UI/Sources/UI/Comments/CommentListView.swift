//
//  CommentListView.swift
//  JSONPlaceholder
//
//  Created by William Dunay on 10/13/20.
//  Copyright © 2020 Bill Dunay. All rights reserved.
//

import Workflows
import Models
import SwiftUI

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
    @StateObject var workflow: CommentListWorkflow
    
    var body: some View {
        VStack {
            if workflow.commentList.isEmpty {
                ProgressView()
                    .progressViewStyle(.circular)
            } else {
                List {
                    ForEach(workflow.commentList, id: \.identifier) { comment in
                        CommentListItem(comment: comment)
                    }
                }
            }
        }
        .navigationBarTitle("Comments")
        .task {
            await self.workflow.getComments()
        }
    }
}

//struct CommentListView_Previews: PreviewProvider {
//    static var previews: some View {
//        guard let posts: [Post] = loadObject(from: "Posts_SingleUser"), let post = posts.first else {
//            fatalError("No posts found in JSON file")
//        }
//        
//        guard let comments: [Comment] = loadObject(from: "Comments_SingleUser") else {
//            fatalError("No comments found in JSON file")
//        }
//        
//        let workflow = CommentListViewModel(post: post, apiClient: JPAClient())
//        viewModel.commentList = comments
//        
//        return NavigationView {
//            CommentListView(viewModel: viewModel)
//        }
//    }
//}
