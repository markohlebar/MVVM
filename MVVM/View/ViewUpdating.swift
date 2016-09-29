//
//  ViewUpdateHandler.swift
//  GIFMash
//
//  Created by Marko Hlebar on 15/06/2016.
//  Copyright © 2016 Marko Hlebar. All rights reserved.
//

import UIKit

public protocol ViewUpdating {
    
    func updateWithViewModel(_ viewModel: ViewModeling)
}

public protocol Reloadable {
    
    func reloadData() -> Void
}

extension UITableView: Reloadable {}
extension UICollectionView: Reloadable {}

/// Convenience handler to reload the Reloadable view on every change.
open class Reloader: ViewUpdating {
    
    open var reloadable: Reloadable?
    
    public init(reloadable: Reloadable?) {
        self.reloadable = reloadable
    }
    
    open func updateWithViewModel(_ viewModel: ViewModeling) {
        reloadable?.reloadData()
    }
}
