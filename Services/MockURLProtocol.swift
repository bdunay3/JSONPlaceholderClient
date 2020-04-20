//
//  MockURLProtocol.swift
//  JSONPlaceholder
//
//  Created by Bill Dunay on 4/20/20.
//  Copyright © 2020 Bill Dunay. All rights reserved.
//

import Foundation

/// This implementation of `URLProtocol` will return the contents of a json file that matches the lastPathComponent of the request

public class MockURLProtocol: URLProtocol {
    /// Call this function before the app starts
    /// This will add what is needed to
    public class func configureMock() {
        URLProtocol.registerClass(MockURLProtocol.self)
    }
    
    public override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    public override class func canInit(with request: URLRequest) -> Bool {
        if let _ = url(for: request) {
            return true
        } else {
            return false
        }
    }
    
    public override func startLoading() {
        guard
            // Check if there's a file
            let fileURL = MockURLProtocol.url(for: request),
            
            // Unwrap request url
            let url = request.url,
            
            // Construct response
            let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil),
            
            // Unwrap the client
            let client = self.client
            
            else { return }
        
        client.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        
        if let data = try? Data(contentsOf: fileURL) {
            client.urlProtocol(self, didLoad: data)
        }
        
        client.urlProtocolDidFinishLoading(self)
    }
    
    public override func stopLoading() {
        
    }
}

// MARK: - Private

private extension MockURLProtocol {
    class func url(for request: URLRequest) -> URL? {
        guard let fileName = request.url?.lastPathComponent,
            let path = Bundle.main.path(forResource: fileName, ofType: nil) else {
                return nil
        }
        
        return URL(fileURLWithPath: path)
    }
}
