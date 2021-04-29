//
//  ExtensionsUICollectionView.swift
//  VK
//
//  Created by Анна on 16.04.2021.
//

import UIKit

extension UICollectionView {
    func apply(delitions: [Int] = [], insertions: [Int] = [], modifications: [Int] = []) {
        performBatchUpdates {
            let delitions = delitions.map { IndexPath(item: $0, section: 0)}
            deleteItems(at: delitions)
            let insertions = insertions.map { IndexPath(item: $0, section: 0)}
            insertItems(at: insertions)
            let modifications = modifications.map { IndexPath(item: $0, section: 0)}
            reloadItems(at: modifications)
        }
    }
}
