//
//  DisplayAlertViewModifier.swift
//  JSONPlaceholder
//
//  Created by Bill Dunay on 1/27/22.
//  Copyright © 2022 Bill Dunay. All rights reserved.
//

import Dependencies
import SwiftUI

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
