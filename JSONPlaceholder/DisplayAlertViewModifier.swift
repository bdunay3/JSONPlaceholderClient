//
//  DisplayAlertViewModifier.swift
//  JSONPlaceholder
//
//  Created by Bill Dunay on 1/27/22.
//  Copyright © 2022 Bill Dunay. All rights reserved.
//

import SwiftUI

public struct AlertableError {
    public struct Action {
        let title: String
        let action: () -> Void
        
        public init(title: String, action: @escaping () -> Void) {
            self.title = title
            self.action = action
        }
    }
    
    let title: String
    let message: String
    let actions: [Action]
    
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

struct DisplayAlertViewModifier: ViewModifier {
    @State var isPresented = true
    
    let error: AlertableError?
    
    func body(content: Content) -> some View {
        alertView(content: content, error: error)
    }
    
    @ViewBuilder
    func alertView(content: Content, error: AlertableError?) -> some View {
        if let error = error {
            if #available(iOS 15, *) {
                content
                    .alert(error.title, isPresented: $isPresented) {
                        alertButtons(for: error.actions)
                    } message: {
                        Text(error.message)
                    }
            } else {
                // iOS 13 & 14 limits you to 1 or 2 buttons in Alerts #frustrating
                content
                    .alert(isPresented: $isPresented) {
                        Alert(title: Text(error.title),
                              message: Text(error.message),
                              dismissButton: .cancel())
                    }
            }
        } else {
            content
        }
    }
    
    @ViewBuilder
    func alertButtons(for actions: [AlertableError.Action]) -> some View {
        ForEach(0..<actions.count, id: \.self) {
            Button(actions[$0].title, action: actions[$0].action)
        }
    }
}

public extension View {
    func customAlert(displaying error: AlertableError?) -> some View {
        modifier(DisplayAlertViewModifier(error: error))
    }
    
    @ViewBuilder
    func customAlert(displaying error: Error?, actions: [AlertableError.Action]) -> some View {
        if let error = error {
            modifier(DisplayAlertViewModifier(error: .init(error: error, actions: actions)))
        } else {
            self
        }
    }
}
