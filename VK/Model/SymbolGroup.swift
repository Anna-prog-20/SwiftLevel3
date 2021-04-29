//
//  SymbolGroup.swift
//  VK
//
//  Created by Анна on 16.04.2021.
//

import Foundation
import RealmSwift

@objcMembers
class SymbolGroup: RealmSwift.Object, Decodable {
    //dynamic var id: String = ""
    dynamic var symbol: String = ""
    //dynamic var groupType: String = ""
    var lastName: String = ""
    
    enum CodingKeys: String, CodingKey {
        case lastName = "last_name"
    }
    
    required convenience init(from decoder: Decoder) {
        self.init()
        let container = try? decoder.container(keyedBy: CodingKeys.self)
        self.lastName = try! container!.decode(String.self, forKey: .lastName)
        self.symbol = self.lastName.first?.uppercased() ?? ""
        //self.groupType = groupType
        //self.id = "\(groupType)_\(symbol)"
    }
    
    override class func primaryKey() -> String? {
        return "symbol"
    }
    
    override class func ignoredProperties() -> [String] {
        return ["lastName"]
    }
}
