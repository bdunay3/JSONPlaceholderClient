//
//  User.swift
//  JSONPlaceholder
//
//  Created by Bill Dunay on 4/20/20.
//  Copyright © 2020 Bill Dunay. All rights reserved.
//

import Foundation

public struct Company: Codable, Hashable, CustomStringConvertible {
    public let name: String
    public let catchPhrase: String
    public let bs: String
    
    public var description: String {
        return "\(name)"
    }
}

public struct GeoLocation: Codable, Hashable, CustomStringConvertible {
    public let lat: String
    public let lng: String
    
    public var description: String {
        return "\(lat), \(lng)"
    }
    
}

public struct Address: Codable, Hashable, CustomStringConvertible {
    public let street: String
    public let suite: String
    public let city: String
    public let zipcode: String
    public let geo: GeoLocation
    
    public var description: String {
        return "\(street), \(city)"
    }
}

public struct User: Codable, Hashable, FileLoadable {
    public enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case name = "name"
        case username = "username"
        case email = "email"
        case address = "address"
        case phone = "phone"
        case website = "website"
        case company = "company"
    }
    
    public let identifier: UInt
    public let name: String
    public let username: String
    public let email: String
    public let address: Address
    public let phone: String
    public let website: String
    public let company: Company
}
