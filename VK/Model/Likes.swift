import Foundation
import RealmSwift

class Likes: RealmSwift.Object, Decodable {
    @objc dynamic var userLikes: Int = 0
    @objc dynamic var count: Int = 0

    enum CodingKeys: String, CodingKey {
        case userLikes = "user_likes"
        case count
    }
    
    required convenience init(from decoder: Decoder) {
        self.init()
        let container = try? decoder.container(keyedBy: CodingKeys.self)
        self.userLikes = try! container!.decode(Int.self, forKey: .userLikes)
        self.count = try! container!.decode(Int.self, forKey: .count)
    }
}
