//
//  Elm.swift
//  JSONPlaceholder
//
//  Created by Bill Dunay on 1/27/22.
//  Copyright © 2022 Bill Dunay. All rights reserved.
//

import Foundation
import SwiftUI

public protocol ViewStateDriven {
    associatedtype State
    
    var viewState: State { get }
}

public protocol MessageActionable {
    associatedtype Message
    
    func send(_ message: Message)
}

public protocol ElmType: ViewStateDriven, MessageActionable { }

public protocol ElmObservable: ElmType, ObservableObject { }
