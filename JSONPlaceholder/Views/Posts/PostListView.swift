//
//  PostListView.swift
//  JSONPlaceholder
//
//  Created by Bill Dunay on 4/29/20.
//  Copyright © 2020 Bill Dunay. All rights reserved.
//

import SwiftUI
import JSONPlaceholderAPI

struct PostListView: View {
    @EnvironmentObject var viewModel: PostsListViewModel
    
    var body: some View {
        List {
            ForEach(viewModel.posts, id: \.identifier) { post in
                VStack(alignment: .leading, spacing: 4) {
                    Text(post.title)
                        .bold()
                    Text(post.body)
                        .multilineTextAlignment(.leading)
                        .font(.body)
                        .lineLimit(nil)
                }
                .lineLimit(nil)
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
        
        let viewModel = PostsListViewModel(with: user, apiClient: JSONPlaceholderApiClient())
        viewModel.posts = posts
        
        return NavigationView {
            PostListView().environmentObject(viewModel)
        }
    }
}
