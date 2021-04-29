import Foundation
import RealmSwift

@objcMembers
class News: RealmSwift.Object, Decodable {
    var id: String = ""
    dynamic var sourceId: Int = 0
    dynamic var date: Int = 0
    dynamic var text: String = ""
    dynamic var attachments: [Attachments]?
    dynamic var comments: CountCategory?
    dynamic var likes: CountCategory?
    
    var countComments: Int = 0
    var countlikes: Int = 0
    var photoURLString: String = ""

    
    enum CodingKeys: String, CodingKey {
        case sourceId = "source_id"
        case date
        case text
        case attachments
        case comments
        case likes
    }
    
    required convenience init(from decoder: Decoder) {
        self.init()
        guard let container = try? decoder.container(keyedBy: CodingKeys.self),
              container != nil else {
            return
        }
        
        if let sourceId = try! container.decodeIfPresent(Int.self, forKey: .sourceId) {
            self.sourceId = sourceId
        }
        if let date = try! container.decodeIfPresent(Int.self, forKey: .date) {
            self.date = date
        }
        self.id = "\(date)_\(sourceId)"
        if let text = try! container.decodeIfPresent(String.self, forKey: .text) {
            self.text = text
        }
        self.attachments = try! container.decodeIfPresent([Attachments].self, forKey: .attachments)
        if let photoURLString = attachments?.first?.photo?.sizes?.first!.url {
            self.photoURLString = photoURLString
        }
        
        self.comments = try! container.decodeIfPresent(CountCategory.self, forKey: .comments)
        if let comments = comments {
            self.countComments = comments.count
        }
        
        self.likes = try! container.decodeIfPresent(CountCategory.self, forKey: .likes)
        if let likes = likes {
            self.countlikes = likes.count
        }
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

@objcMembers
class Attachments: Decodable {
    dynamic var type: String = ""
    dynamic var photo: Photo?
    
    enum CodingKeys: String, CodingKey {
        case type, photo
    }
    
    required convenience init(from decoder: Decoder) {
        self.init()
        let container = try? decoder.container(keyedBy: CodingKeys.self)
        self.type = try! container!.decode(String.self, forKey: .type)
        self.photo = try! container!.decodeIfPresent(Photo.self, forKey: .photo)
    }
}

@objcMembers
class CountCategory: Decodable {
    dynamic var count: Int = 0
    
    enum CodingKeys: String, CodingKey {
        case count
    }
    
    required convenience init(from decoder: Decoder) {
        self.init()
        let container = try? decoder.container(keyedBy: CodingKeys.self)
        self.count = try! container!.decode(Int.self, forKey: .count)
    }
}
