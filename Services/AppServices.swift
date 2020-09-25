//
//  AppServices.swift
//  JSONPlaceholder
//
//  Created by William Dunay on 9/10/20.
//  Copyright © 2020 Bill Dunay. All rights reserved.
//

import Foundation

public protocol JSONPlaceholderApiClientProvider {
    var apiClient: JPAClientType { get }
}

public protocol AppServicesProvider: JSONPlaceholderApiClientProvider {
    static var shared: AppServicesProvider { get }
}

public class AppServices: AppServicesProvider {
    public static let shared: AppServicesProvider = AppServices()
    
    public let apiClient: JPAClientType
    
    init(apiClient: JPAClientType? = nil) {
        self.apiClient = apiClient ?? JPAClient()
    }
}
