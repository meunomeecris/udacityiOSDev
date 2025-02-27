
import Foundation

struct UserData: Codable {
    let results: [User]
}

struct User: Codable, Identifiable {
    private(set) var name: Name
    private(set) var email: String
    private(set) var dateOfBirth: DateOfBirth
    private(set) var picture: Picture
    private(set) var location: Location

    var id: String { UUID().uuidString }

    var fullname: String {
        name.first + " " + name.last
    }

    var fullAddress: String {
        return "\(location.street.number) \(location.street.name), \(location.city), \(location.state), \(location.country)"
    }

    enum CodingKeys: String, CodingKey {
        case name, email, location, picture
        case dateOfBirth = "dob" // Maps 'dob' in JSON to 'dateOfBirth' in the Swift model.
    }
}

struct Name: Codable {
    let title: String
    let first: String
    let last: String
}

struct DateOfBirth: Codable {
    var date: String
}

struct Picture: Codable {
    let large: String
    let medium: String
    let thumbnail: String
}

struct Location: Codable {
    let street: Street
    let city: String
    let state: String
    let country: String
}

struct Street: Codable {
    let number: Int
    let name: String
}
