//
//  Dependencies.swift
//  JSONPlaceholder
//
//  Created by Bill Dunay on 1/30/22.
//  Copyright © 2022 Bill Dunay. All rights reserved.
//

import Foundation
import RESTClient
import Workflows

typealias BackendClient = RESTClientType & CombineClientType & AsyncClientType

extension JPAClient: BackendClient { }

final class Dependencies: ObservableObject {
    let restClient: BackendClient
    
    init(restClient: BackendClient) {
        self.restClient = restClient
    }
    
    convenience init(environment: BackendEnvironment) {
        self.init(restClient: JPAClient(environment: environment))
    }
}
