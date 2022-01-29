//
//  AppWorkflow.swift
//  
//
//  Created by Bill Dunay on 1/29/22.
//

import Foundation
import Models
import SwiftUI

public final class AppWorkflow: ObservableObject {
    @Published public private(set) var viewState: ViewState = .showUserList
    
    public init() { }
}

extension AppWorkflow: ElmObservable {
    public typealias State = ViewState
    public typealias Message = UserAction
    
    public enum ViewState {
        case showUserList
        case showUser(User)
    }
    
    public enum UserAction {
        case selectedUser(User)
        case logout
    }
    
    public func send(_ message: UserAction) {
        switch message {
            case .selectedUser(let selectedUser):
                viewState = .showUser(selectedUser)
                
            case .logout:
                viewState = .showUserList
        }
    }
}
