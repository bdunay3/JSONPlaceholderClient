//
//  AlertableError.swift
//  
//
//  Created by Bill Dunay on 1/29/22.
//

import Foundation

public struct AlertableError {
    public struct Action {
        public let title: String
        public let action: () -> Void
        
        public init(title: String, action: @escaping () -> Void) {
            self.title = title
            self.action = action
        }
    }
    
    public let title: String
    public let message: String
    public let actions: [Action]
    
    public init(title: String, message: String, actions: [Action]) {
        self.title = title
        self.message = message
        self.actions = actions
    }
}

extension AlertableError {
    public init(error: Error, actions: [Action]) {
        self.title = "Error"
        self.message = error.localizedDescription
        self.actions = actions
    }
}
