//
//  RealmBase.swift
//  VK
//
//  Created by Анна on 13.04.2021.
//

import Foundation
import RealmSwift

class RealmBase {
    static let inctance = RealmBase()
    
    private init() {
    }
    
    private var realm: Realm?

    func startRealmBase() {
        let config = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
        do {
            self.realm = try Realm(configuration: config)
        } catch {
            print(error)
        }
    }
    
    func getRealm() -> Realm? {
        return realm
    }
}
