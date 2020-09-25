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
    typealias Value = JPAClientType
    static var defaultValue: JPAClientType = JPAClient()
}

extension EnvironmentValues {
    var apiClient: JPAClientType {
        get { return self[ApiClientKey] }
        set { self[ApiClientKey] = newValue }
    }
}
