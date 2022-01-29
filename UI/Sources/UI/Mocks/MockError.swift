//
//  MockError.swift.swift
//  
//
//  Created by Bill Dunay on 2/21/22.
//

import Foundation

#if DEBUG
struct MockError: LocalizedError {
    var errorDescription: String? {
        "This is a test error."
    }
}
#endif
