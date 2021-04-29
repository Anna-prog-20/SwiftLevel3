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
    
    func apply(results: [User] = [], sections: Results<SymbolGroup>?, delitions: [Int] = [], insertions: [Int] = [], modifications: [Int] = []) {
        performBatchUpdates {
            beginUpdates()
            let insertions = insertions.map {
                IndexPath(item: $0, section: searchNumberSection(results: results, currentIndex: $0, sections: sections))}
            insertRows(at: insertions, with: .automatic)
            let delitions = delitions.map {
                IndexPath(item: $0, section: searchNumberSection(results: results, currentIndex: $0, sections: sections))}
            deleteRows(at: delitions, with: .automatic)
            let modifications = modifications.map {
                IndexPath(item: $0, section: searchNumberSection(results: results, currentIndex: $0, sections: sections))}
            reloadRows(at: modifications, with: .automatic)
            endUpdates()
        }
    }
    
    private static var numberSection = 0
    private func searchNumberSection(results: [User], currentIndex: Int, sections: Results<SymbolGroup>?) -> Int {
       let currentSection = sections?.filter("symbol LIKE '\(results[currentIndex].lastName.first!)*'").first!
        if (currentIndex - 1 < results.count)&&(currentIndex >= 1)&&(currentIndex != 0) {
            let backSection = sections?.filter("symbol LIKE '\(results[currentIndex - 1].lastName.first!)*'").first!
            if currentSection != backSection {
                UITableView.numberSection = UITableView.numberSection + 1
            }
        }
        return UITableView.numberSection
    }
}
