//
//  AlbumsViewModel.swift
//  JSONPlaceholder
//
//  Created by Bill Dunay on 4/30/20.
//  Copyright © 2020 Bill Dunay. All rights reserved.
//

import Foundation
import JSONPlaceholderAPI
import Combine

class AlbumsViewModel: ObservableObject {
    @Published var listOfAlbums = [Album]()
    @Published private(set) var error: (isShowing: Bool, message: String?) = (isShowing: false, message: nil)
    
    private let user: User
    private let apiClient: JPAClientCombineType
    private var cancellationToken: AnyCancellable?
    
    init(user: User, apiClient: JPAClientCombineType) {
        self.apiClient = apiClient
        self.user = user
    }
    
    func getAlbums() {
        cancellationToken = apiClient.getAlbumsTask(for: user)
            .sink(receiveCompletion: { complete in
                switch complete {
                case .failure(let error):
                    print(error.localizedDescription)
                case .finished:
                    break
                }
            }, receiveValue: { (fetchedAlbums) in
                self.listOfAlbums = fetchedAlbums
            })
    }
}
