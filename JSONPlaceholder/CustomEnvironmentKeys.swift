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
    static var defaultValue: JSONPlaceholderApiClient = JSONPlaceholderApiClient()
}

extension ApiClientKey {
    var apiClient: JSONPlaceholderApiClient {
        get { return ApiClientKey.defaultValue }
        set { ApiClientKey.defaultValue = newValue }
    }
}
