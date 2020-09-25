//
//  AlbumsListView.swift
//  JSONPlaceholder
//
//  Created by Bill Dunay on 4/30/20.
//  Copyright © 2020 Bill Dunay. All rights reserved.
//

import SwiftUI
import JSONPlaceholderAPI
import Combine

struct AlbumRowView: View {
    let album: Album
    
    var body: some View {
        Text(album.title)
    }
}

struct AlbumsListView: View {
    @ObservedObject var viewModel: AlbumsViewModel
    
    var body: some View {
        List(viewModel.listOfAlbums, id: \.identifier) { album in
            AlbumRowView(album: album)
        }
        .onAppear {
            self.viewModel.getAlbums()
        }
        .navigationBarTitle("Albums")
    }
}

struct AlbumsListView_Previews: PreviewProvider {
    static var previews: some View {
        guard let users: [User] = loadObject(from: "User_Single"), let user = users.first else {
            fatalError("No users found in JSON file")
        }
        
        guard let albums: [Album] = loadObject(from: "Albums_SingleUser") else {
            fatalError("No users found in JSON file")
        }
        
        let viewModel = AlbumsViewModel(user: user, apiClient: JPAClient())
        viewModel.listOfAlbums = albums
        
        return NavigationView {
            AlbumsListView(viewModel: viewModel)
        }
    }
}
