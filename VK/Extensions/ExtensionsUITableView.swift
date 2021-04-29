//
//  ExtensionsUITableView.swift
//  VK
//
//  Created by Анна on 16.04.2021.
//

import UIKit
import RealmSwift

extension UITableView {
    func apply(delitions: [Int] = [], insertions: [Int] = [], modifications: [Int] = []) {
        performBatchUpdates {
            beginUpdates()
            let delitions = delitions.map { IndexPath(item: $0, section: 0)}
            deleteRows(at: delitions, with: .automatic)
            let insertions = insertions.map { IndexPath(item: $0, section: 0)}
            insertRows(at: insertions, with: .automatic)
            let modifications = modifications.map { IndexPath(item: $0, section: 0)}
            reloadRows(at: modifications, with: .automatic)
            endUpdates()
        }
    }
    
    func apply(results: [User] = [], sections: [String], delitions: [Int] = [], insertions: [Int] = [], modifications: [Int] = []) {
        performBatchUpdates {
            beginUpdates()
            let insertions = insertions.map {
                IndexPath(item: $0, section: searchNumberSection(result: results[$0], sections: sections))}
            insertRows(at: insertions, with: .automatic)
            let delitions = delitions.map {
                IndexPath(item: $0, section: searchNumberSection(result: results[$0], sections: sections))}
            deleteRows(at: delitions, with: .automatic)
            let modifications = modifications.map {
                IndexPath(item: $0, section: searchNumberSection(result: results[$0], sections: sections))}
            reloadRows(at: modifications, with: .automatic)
            endUpdates()
        }
    }
    
    private static var numberSection = 0
    private func searchNumberSection(result: User, sections: [String]) -> Int {
        var i = 0
        while sections[i] !=  result.lastName.first?.uppercased(){
            i = i + 1
        }
        return i
    }
}
