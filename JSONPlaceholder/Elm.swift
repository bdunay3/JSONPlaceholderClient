//
//  Elm.swift
//  JSONPlaceholder
//
//  Created by Bill Dunay on 1/27/22.
//  Copyright © 2022 Bill Dunay. All rights reserved.
//

import Foundation
import SwiftUI

public protocol ElmType {
    associatedtype Message
    associatedtype State
    
    var viewState: State { get }
    
    func send(_ message: Message)
}

public protocol ElmObservable: ElmType, ObservableObject { }
