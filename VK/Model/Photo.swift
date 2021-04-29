import Foundation
import RealmSwift

@objcMembers
class Photo: RealmSwift.Object, Decodable {
    dynamic var albumID: Int = 0
    dynamic var date: Int = 0
    dynamic var id: Int = 0
    dynamic var ownerID: Int = 0
    dynamic var hasTags: Bool = true
    dynamic var sizes: [Size]?
    dynamic var text: String = ""
    var likes: Likes?
    
    var sizesList = List<Size>()
    
    enum CodingKeys: String, CodingKey {
        case albumID = "album_id"
        case date, id
        case ownerID = "owner_id"
        case hasTags = "has_tags"
        case sizes
        case text
        case likes
    }
    
    required convenience init(from decoder: Decoder) {
        self.init()
        let container = try? decoder.container(keyedBy: CodingKeys.self)
        self.albumID = try! container!.decode(Int.self, forKey: .albumID)
        self.date = try! container!.decode(Int.self, forKey: .date)
        self.id = try! container!.decode(Int.self, forKey: .id)
        self.ownerID = try! container!.decode(Int.self, forKey: .ownerID)
        self.hasTags = try! container!.decode(Bool.self, forKey: .hasTags)
        self.sizes = try! container!.decode([Size].self, forKey: .sizes)
        self.text = try! container!.decode(String.self, forKey: .text)
        self.likes = try! container!.decodeIfPresent(Likes.self, forKey: .likes)
        self.sizesList.append(objectsIn: sizes!)
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
    override class func ignoredProperties() -> [String] {
        return ["sizes"]
    }
}

@objcMembers
class Size: RealmSwift.Object, Decodable {
    dynamic var height: Int = 0
    dynamic var url: String = ""
    dynamic var type: String = ""
    dynamic var width: Int = 0
    
    dynamic var owners = LinkingObjects(fromType: Photo.self, property: "sizesList")
    
    enum CodingKeys: String, CodingKey {
        case height, url, type, width
    }
    
    required convenience init(from decoder: Decoder) {
        self.init()
        let container = try? decoder.container(keyedBy: CodingKeys.self)
        self.height = try! container!.decode(Int.self, forKey: .height)
        self.url = try! container!.decode(String.self, forKey: .url)
        self.type = try! container!.decode(String.self, forKey: .type)
        self.width = try! container!.decode(Int.self, forKey: .width)
    }
    
    override class func primaryKey() -> String? {
        return "url"
    }
}
