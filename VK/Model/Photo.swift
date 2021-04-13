import Foundation

struct Photo: Decodable {
    let albumID, date, id, ownerID: Int
    let hasTags: Bool
    let sizes: [Size]
    let text: String
    let likes: Likes

    enum CodingKeys: String, CodingKey {
        case albumID = "album_id"
        case date, id
        case ownerID = "owner_id"
        case hasTags = "has_tags"
        case sizes
        case text
        case likes
    }
}

struct Size: Decodable {
    let height: Int
    let url: String
    let type: String
    let width: Int
}
