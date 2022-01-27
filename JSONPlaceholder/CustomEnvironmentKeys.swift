//
//  CustomEnvironmentKeys.swift
//  JSONPlaceholder
//
//  Created by Bill Dunay on 4/30/20.
//  Copyright © 2020 Bill Dunay. All rights reserved.
//

import Foundation
import SwiftUI
import JSONPlaceholderAPI

struct ApiClientKey: EnvironmentKey {
    typealias Value = JPAClientCombineType
    static var defaultValue: JPAClientCombineType = JPAClient()
}

@available(iOS 15.0, *)
struct AsyncApiClientKey: EnvironmentKey {
    typealias Value = JPAClientAsyncType
    static var defaultValue: JPAClientAsyncType = JPAClient()
}

extension EnvironmentValues {
    var apiClient: JPAClientCombineType {
        get { return self[ApiClientKey.self] }
        set { self[ApiClientKey.self] = newValue }
    }
    
    @available(iOS 15.0, *)
    var asyncApiClient: JPAClientAsyncType {
        get { return self[AsyncApiClientKey.self] }
        set { self[AsyncApiClientKey.self] = newValue }
    }
}
