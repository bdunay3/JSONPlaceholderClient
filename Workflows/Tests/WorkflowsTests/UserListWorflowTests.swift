//
//  UserListWorflowTests.swift
//
//  Created by Bill Dunay on 4/20/20.
//  Copyright © 2020 Bill Dunay. All rights reserved.
//

import Combine
import Models
import XCTest

@testable import Workflows

class UserListWorflowTests: XCTestCase {
    var mockApiClient: MockCombineApi!
    var subject: UserListWorkflow!
    
    var cancellables = [AnyCancellable]()
    
    override func setUp() {
        super.setUp()
        
        mockApiClient = MockCombineApi()
        
        subject = UserListWorkflow(dependencies: .init(combineClient: mockApiClient, onSelectedUser: { _ in }))
    }
    
    override func tearDown() {
        super.tearDown()
        
        subject = nil
        mockApiClient = nil
    }
    
    func testLoadAction_AwaitPublisher() throws {
        let expectedResult = [
            User(identifier: 0, name: "Bob", username: "bob", email: "b@ob.com",
                 address: .init(street: "",
                                suite: "",
                                city: "",
                                zipcode: "",
                                geo: .init(lat: "", lng: "")),
                 phone: "",
                 website: "",
                 company: .init(name: "Foo",
                                catchPhrase: "Baz",
                                bs: "Bar"))
        ]
        
        mockApiClient.getUserPublisher = CurrentValueSubject<[User], Error>(expectedResult)
            .eraseToAnyPublisher()
        
        let viewStatePublisher = subject.$viewState
            .collect(2)
            .first()
        
        subject.send(.load)
        
        let viewStates = try awaitPublisher(viewStatePublisher, cancellables: &cancellables)
        XCTAssertEqual(viewStates.count, 2)

        guard case .loading = viewStates.first else {
            XCTFail("viewState[0] = \(viewStates.first?.description ?? "")")
            return
        }

        guard case .loaded(let users, let displayError) = viewStates.last else {
            XCTFail("viewState[0] = \(viewStates.first?.description ?? "")")
            return
        }

        XCTAssertEqual(users, expectedResult)
        XCTAssertNil(displayError)
    }
}
