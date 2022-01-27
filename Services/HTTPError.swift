//
//  HTTPError.swift
//  JSONPlaceholderAPI
//
//  Created by Bill Dunay on 7/1/21.
//  Copyright © 2021 Bill Dunay. All rights reserved.
//

import Foundation

public enum HTTPError: LocalizedError {
    case notHttpResponse
    case statusCode(Int)
    case noDataInResponse
    case wrongDataReturned
    
    public var failureReason: String? {
        switch self {
            
        case .notHttpResponse:
            return "Data returned was not an HTTP protocol response."
            
        case .statusCode(let statusCode):
            return "HTTP Status code: \(statusCode)"
            
        case .noDataInResponse:
            return "Expected data in HTTP body but none was recieved."
            
        case .wrongDataReturned:
            return "Unexpected data in respose"
        }
    }
}
