import Foundation

struct User: Decodable {
    let id: Int
    let firstName, lastName: String
    let isClosed, canAccessClosed: Bool
    let photo100: String

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case isClosed = "is_closed"
        case canAccessClosed = "can_access_closed"
        case photo100 = "photo_100"
    }
}
