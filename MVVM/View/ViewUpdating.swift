//
//  ViewUpdateHandler.swift
//  GIFMash
//
//  Created by Marko Hlebar on 15/06/2016.
//  Copyright © 2016 Marko Hlebar. All rights reserved.
//

#if os(iOS) || os(tvOS)
import UIKit
#endif

#if os(iOS) || os(tvOS)
extension UITableView: Reloadable {}
extension UICollectionView: Reloadable {}
#endif

public protocol ViewUpdating {
    
    func update(with viewModel: ViewModeling)
}

public protocol Reloadable: class {
    
    func reloadData() -> Void
}

/// Convenience handler to reload the Reloadable view on every change.
open class Reloader: ViewUpdating {
    
    open weak var reloadable: Reloadable?
    
    public init(reloadable: Reloadable?) {
        self.reloadable = reloadable
    }
    
    open func update(with viewModel: ViewModeling) {
        reloadable?.reloadData()
    }
}
