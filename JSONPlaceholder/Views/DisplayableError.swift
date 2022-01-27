//
//  Error+SwiftUI_Alert.swift
//  JSONPlaceholder
//
//  Created by Bill Dunay on 7/1/21.
//  Copyright © 2021 Bill Dunay. All rights reserved.
//

import Foundation
import SwiftUI

protocol DisplayableError: View {}

protocol DisplayableErrorHandlable: AnyObject {
    var showErrorMessage: Bool { get set }
    
    var currentError: Error? { get set }
    var displayedErrorMessage: String { get }
}

extension DisplayableErrorHandlable {
    var displayedErrorMessage: String {
        currentError?.localizedDescription ?? "No Error"
    }
    
    func clearError() {
        showErrorMessage = false
        currentError = nil
    }
}
