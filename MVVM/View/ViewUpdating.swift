//
//  ViewUpdateHandler.swift
//  GIFMash
//
//  Created by Marko Hlebar on 15/06/2016.
//  Copyright © 2016 Marko Hlebar. All rights reserved.
//

import Foundation

public protocol ViewUpdating {
    
    func updateWithViewModel(viewModel: ViewModeling)
}

public protocol Reloadable {
    
    func reloadData() -> Void
}

extension UITableView: Reloadable {}
extension UICollectionView: Reloadable {}

/// Convenience handler to reload the Reloadable view on every change.
public class Reloader: ViewUpdating {
    
    public var reloadable: Reloadable?
    
    public init(reloadable: Reloadable?) {
        self.reloadable = reloadable
    }
    
    public func updateWithViewModel(viewModel: ViewModeling) {
        reloadable?.reloadData()
    }
}
