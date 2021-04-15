import Foundation
import RealmSwift

struct Album: Decodable {
    let id: Int
    let ownerID: Int
    let title: String
    let thumbSrc: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case ownerID = "owner_id"
        case title
        case thumbSrc = "thumb_src"
    }
}
