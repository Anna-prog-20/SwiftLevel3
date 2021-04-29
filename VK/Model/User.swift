import Foundation
import RealmSwift

@objcMembers
class User: RealmSwift.Object, Decodable {
    dynamic var id: Int = 0
    dynamic var firstName: String = ""
    dynamic var lastName: String = ""
    var symbolName: String = ""
    dynamic var photo100: String = ""

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case photo100 = "photo_100"
    }
    
    required convenience init(from decoder: Decoder) {
        self.init()
        let container = try? decoder.container(keyedBy: CodingKeys.self)
        self.id = try! container!.decode(Int.self, forKey: .id)
        self.firstName = try! container!.decode(String.self, forKey: .firstName)
        self.lastName = try! container!.decode(String.self, forKey: .lastName)
        self.symbolName = self.lastName.first!.uppercased() ?? ""
        self.photo100 = try! container!.decode(String.self, forKey: .photo100)
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
