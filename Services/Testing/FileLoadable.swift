//
//  FileLoadable.swift
//  JSONPlaceholder
//
//  Created by Bill Dunay on 4/26/20.
//  Copyright © 2020 Bill Dunay. All rights reserved.
//

import Foundation

let frameworkIdentifier = "com.test.JSONPlaceholderAPI"

public func loadObject<T: Decodable>(from fileName: String, `extension`: String = "json") -> T? {
    guard let frameworkBundle = Bundle(identifier: frameworkIdentifier) else {
        assertionFailure("\(frameworkIdentifier) is not a valid Bundle Identifier in this project!")
        return nil
    }
    
    return loadObject(from: fileName, extension: `extension`, inBundle: frameworkBundle)
}

public func loadObject<T: Decodable>(from fileName: String, `extension`: String = "json", inBundle bundle: Bundle) -> T? {
    let fileManager = FileManager.default
    
    guard let pathForResource = bundle.path(forResource: fileName, ofType: `extension`) else {
        assertionFailure("Failed to get path to file named: \(fileName).\(`extension`)")
        return nil
    }
    
    guard let fileData = fileManager.contents(atPath: pathForResource) else {
        assertionFailure("Failed to load \(fileName).\(`extension`) at path: \(pathForResource)")
        return nil
    }
    
    let decoder = JSONDecoder()
    do {
        let decodedJsonType = try decoder.decode(T.self, from: fileData)
        return decodedJsonType
        
    } catch {
        assertionFailure("Failed to decode JSON from file \(fileName).\(`extension`). Reason: \(error.localizedDescription)")
    }
    
    return nil
}
