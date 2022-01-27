//
//  JSONPlaceholderTests.swift
//  JSONPlaceholderTests
//
//  Created by Bill Dunay on 4/20/20.
//  Copyright © 2020 Bill Dunay. All rights reserved.
//

import Combine
import XCTest

import JSONPlaceholderAPI
@testable import JSONPlaceholder

class UserListViewModelTests: XCTestCase {
    var mockApiClient: MockCombineApi!
    var mockCurrentUser: CurrentUser!
    var subject: UserListViewModel!
    
    var cancellables = [AnyCancellable]()
    
    override func setUp() {
        super.setUp()
        
        mockApiClient = MockCombineApi()
        mockCurrentUser = CurrentUser()
        
        subject = UserListViewModel(apiClient: mockApiClient, currentUser: mockCurrentUser)
    }
    
    override func tearDown() {
        super.tearDown()
        
        subject = nil
        mockCurrentUser = nil
        mockApiClient = nil
    }
    
    func testLoadAction_Expectations() {
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
        var viewStates = [UserListViewModel.ViewState]()
        let expectation = XCTestExpectation(description: "Waiting for load action to complete.")

        mockApiClient.getUserPublisher = CurrentValueSubject<[User], Error>(expectedResult)
            .eraseToAnyPublisher()

        subject.$viewState
            .dropFirst()
            .collect(2)
            .first()
            .sink(receiveCompletion: { _ in
                expectation.fulfill()
            }, receiveValue: {
                viewStates = $0
            })
            .store(in: &cancellables)

        subject.send(.load)

        wait(for: [expectation], timeout: 1)
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
