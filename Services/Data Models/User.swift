//
//  User.swift
//  JSONPlaceholder
//
//  Created by Bill Dunay on 4/20/20.
//  Copyright © 2020 Bill Dunay. All rights reserved.
//

import Foundation

struct Company: Codable, Hashable, CustomStringConvertible {
    let name: String
    let catchPhrase: String
    let bs: String
    
    var description: String {
        return "\(name)"
    }
}

struct GeoLocation: Codable, Hashable, CustomStringConvertible {
    let lat: String
    let lng: String
    
    var description: String {
        return "\(lat), \(lng)"
    }
    
}

struct Address: Codable, Hashable, CustomStringConvertible {
    let street: String
    let suite: String
    let city: String
    let zipcode: String
    let geo: GeoLocation
    
    var description: String {
        return "\(street), \(city)"
    }
}

struct User: Codable, Hashable {
    enum CodingKeys: String, CodingKey {
        case indentifier = "id"
        case name = "name"
        case username = "username"
        case email = "email"
        case address = "address"
        case phone = "phone"
        case website = "website"
        case company = "company"
    }
    
    let indentifier: UInt
    let name: String
    let username: String
    let email: String
    let address: Address
    let phone: String
    let website: String
    let company: Company
}
