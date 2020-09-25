//
//  PostListView.swift
//  JSONPlaceholder
//
//  Created by Bill Dunay on 4/29/20.
//  Copyright © 2020 Bill Dunay. All rights reserved.
//

import SwiftUI
import JSONPlaceholderAPI

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

struct PostListView: View {
    @ObservedObject var viewModel: PostsListViewModel
    
    var body: some View {
        List {
            ForEach(viewModel.posts, id: \.identifier) { post in
                PostItemView(post: post)
            }
        }
        .navigationBarTitle("Posts")
        .onAppear {
            self.viewModel.getPosts()
        }
    }
}

struct PostListView_Previews: PreviewProvider {
    static var previews: some View {
        guard let users: [User] = loadObject(from: "User_Single"), let user = users.first else {
            fatalError("No users found in JSON file")
        }
        
        guard let posts: [Post] = loadObject(from: "Posts_SingleUser") else {
            fatalError("No posts found in JSON file")
        }
        
        let viewModel = PostsListViewModel(with: user, apiClient: JPAClient())
        viewModel.posts = posts
        
        return NavigationView {
            PostListView(viewModel: viewModel)
        }
    }
}
