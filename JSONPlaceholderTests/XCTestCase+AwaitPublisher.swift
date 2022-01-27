//
//  XCTestCase+AwaitPublisher.swift
//  JSONPlaceholderTests
//
//  Created by Bill Dunay on 1/27/22.
//  Copyright © 2022 Bill Dunay. All rights reserved.
//

import Combine
import XCTest

extension XCTestCase {
    func awaitPublisher<T: Publisher>(_ publisher: T, timeout: TimeInterval = 2, cancellables: inout [AnyCancellable], file: StaticString = #file, line: UInt = #line)
    throws -> T.Output {
        // This time, we use Swift's Result type to keep track
        // of the result of our Combine pipeline:
        var result: Result<T.Output, Error>?
        let expectation = XCTestExpectation(description: "Awaiting publisher")

        publisher
            .sink(
            receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    result = .failure(error)
                case .finished:
                    break
                }

                expectation.fulfill()
            },
            receiveValue: { value in
                result = .success(value)
            }
        )
            .store(in: &cancellables)

        // Just like before, we await the expectation that we
        // created at the top of our test, and once done, we
        // also cancel our cancellable to avoid getting any
        // unused variable warnings:
        wait(for: [expectation], timeout: timeout)

        // Here we pass the original file and line number that
        // our utility was called at, to tell XCTest to report
        // any encountered errors at that original call site:
        let unwrappedResult = try XCTUnwrap(result, "Awaited publisher did not produce any output", file: file, line: line)

        return try unwrappedResult.get()
    }
}
