import Foundation

// MARK: - User Model
struct User: Codable, Equatable {
    let id: Int
    let name: String
    let username: String
    let email: String
    let phone: String
    let website: String
    let address: Address
    let company: Company
}

// MARK: - Address Model
struct Address: Codable, Equatable {
    let street: String
    let suite: String
    let city: String
    let zipcode: String
    let geo: Geo
}

// MARK: - Geo Model
struct Geo: Codable, Equatable {
    let lat: String
    let lng: String
}

// MARK: - Company Model
struct Company: Codable, Equatable {
    let name: String
    let catchPhrase: String
    let bs: String
} 