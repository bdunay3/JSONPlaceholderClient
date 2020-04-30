//
//  Environment.swift
//  JSONPlaceholder
//
//  Created by Bill Dunay on 4/28/20.
//  Copyright © 2020 Bill Dunay. All rights reserved.
//

import Foundation

public enum Environment {
    case production
    case qa
    case debug
    
    var baseUrlString: String {
        switch self {
        case .production:
            return "https://jsonplaceholder.typicode.com"
            
        default:
            fatalError("Someone forgot to add a base url string for case \(self)")
        }
    }
    
    var baseUrl: URL {
        guard let serverUrl = URL(string: baseUrlString) else {
            fatalError("Failed to create URL instance from address \"\(baseUrlString)\"")
        }
        
        return serverUrl
    }
    
    func url(endPoint: String, queryParameters: [URLQueryItem]) -> URL {
        var urlComponents = URLComponents()
        urlComponents.path = endPoint
        urlComponents.queryItems = queryParameters
        
        guard let finalURL = urlComponents.url(relativeTo: baseUrl) else {
            fatalError("Failed to construct proper Query URL for endpoint \(endPoint)")
        }
        return finalURL
    }
}
