//
//  Array+Extensions.swift
//  JSONPlaceholder
//
//  Created by Bill Dunay on 4/28/20.
//  Copyright © 2020 Bill Dunay. All rights reserved.
//

import Foundation
//
public extension Array {
    subscript(safe index: Int) -> Element? {
        return index >= startIndex && index < endIndex ? self[index] : nil
    }
}
