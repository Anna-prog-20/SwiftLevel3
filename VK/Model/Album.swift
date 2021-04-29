import Foundation
import RealmSwift

@objcMembers
class Album: RealmSwift.Object, Decodable {
    var idKey:String = ""
    dynamic var id: Int = 0
    dynamic var ownerID: Int = 0
    dynamic var title: String = ""
    dynamic var thumbSrc: String = ""
    
    enum CodingKeys: String, CodingKey {
        case id
        case ownerID = "owner_id"
        case title
        case thumbSrc = "thumb_src"
    }
    
    required convenience init(from decoder: Decoder) {
        self.init()
        let container = try? decoder.container(keyedBy: CodingKeys.self)
        self.id = try! container!.decode(Int.self, forKey: .id)
        self.ownerID = try! container!.decode(Int.self, forKey: .ownerID)
        self.idKey = "\(ownerID)_\(id)"
        self.title = try! container!.decode(String.self, forKey: .title)
        self.thumbSrc = try! container!.decode(String.self, forKey: .thumbSrc)
        print("Альбом id \(id) ownerID \(ownerID)")
    }
    
    override class func primaryKey() -> String? {
        return "idKey"
    }
}
