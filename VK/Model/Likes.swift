import Foundation

struct Likes: Decodable {
    let userLikes: Int
    let count: Int

    enum CodingKeys: String, CodingKey {
        case userLikes = "user_likes"
        case count
    }
}
