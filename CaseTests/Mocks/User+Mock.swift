import Foundation
@testable import Case

extension User {
    static func mock(
        id: Int = 1,
        name: String = "John Doe",
        username: String = "johndoe",
        email: String = "john@example.com",
        phone: String = "123-456-7890",
        website: String = "example.com",
        address: Address = .mock(),
        company: Company = .mock()
    ) -> User {
        User(
            id: id,
            name: name,
            username: username,
            email: email,
            phone: phone,
            website: website,
            address: address,
            company: company
        )
    }
}

extension Address {
    static func mock(
        street: String = "123 Main St",
        suite: String = "Apt 4B",
        city: String = "New York",
        zipcode: String = "10001",
        geo: Geo = .mock()
    ) -> Address {
        Address(
            street: street,
            suite: suite,
            city: city,
            zipcode: zipcode,
            geo: geo
        )
    }
}

extension Geo {
    static func mock(
        lat: String = "40.7128",
        lng: String = "74.0060"
    ) -> Geo {
        Geo(lat: lat, lng: lng)
    }
}

extension Company {
    static func mock(
        name: String = "Example Corp",
        catchPhrase: String = "Making the world a better place",
        bs: String = "innovative solutions"
    ) -> Company {
        Company(
            name: name,
            catchPhrase: catchPhrase,
            bs: bs
        )
    }
} 