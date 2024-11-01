//
//  UICollectionView+.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 24/01/2024.
//

import UIKit

extension UICollectionView {

    func dequeueCell<T: UICollectionViewCell>(ofType type: T.Type, for indexPath: IndexPath) -> T {
        return self.dequeueReusableCell(withReuseIdentifier: String(describing: T.self), for: indexPath) as! T
    }
    
    func dequeueHeaderFooterView<T: UICollectionReusableView>(ofType type: T.Type, forKind kind: String, for indexPath: IndexPath) -> T {
        let identifier = String(describing: T.self)
        guard let view = dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: identifier, for: indexPath) as? T else {
            fatalError("Could not dequeue view with identifier: \(identifier) or it couldn't be cast to \(T.self)")
        }
        return view
    }
    
    func dequeueHeaderHeaderView<T: UICollectionReusableView>(ofType type: T.Type, forKind kind: String, for indexPath: IndexPath) -> T {
        let identifier = String(describing: T.self)
        guard let view = dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: identifier, for: indexPath) as? T else {
            fatalError("Could not dequeue view with identifier: \(identifier) or it couldn't be cast to \(T.self)")
        }
        return view
    }

    func registerCellFromNib<T: UICollectionViewCell>(ofType type: T.Type) {
        let id = String(describing: T.self)
        self.register(UINib(nibName: id, bundle: UIStoryboard.bundle), forCellWithReuseIdentifier: id)
    }
    
    func registerCustomViewFromNib<T: UICollectionReusableView>(ofType type: T.Type, forKind kind: String) {
        let identifier = String(describing: T.self)
        self.register(UINib(nibName: identifier, bundle: UIStoryboard.bundle), forSupplementaryViewOfKind: kind, withReuseIdentifier: identifier)
    }

    

    func isValid(indexPath: IndexPath) -> Bool {
        guard indexPath.section < numberOfSections,
            indexPath.row < numberOfItems(inSection: indexPath.section)
            else { return false }
        return true
    }
    
    
}

