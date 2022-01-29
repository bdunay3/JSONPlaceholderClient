//
//  Helpers.swift
//  JSONPlaceholderTests
//
//  Created by Bill Dunay on 1/27/22.
//  Copyright © 2022 Bill Dunay. All rights reserved.
//

import Foundation

@testable import Workflows

extension UserListWorkflow.ViewState: CustomStringConvertible {
    public var description: String {
        switch self {
        case .inital:
            return "inital"
        case .loading:
            return "loading"
        case .loaded(let users, let error):
            return "User List:\n\(users)\nError:\(error != nil ? "" : "Has Error To Display")"
        }
    }
}
