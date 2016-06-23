//
//  View.swift
//  GIFMash
//
//  Created by Marko Hlebar on 17/06/2016.
//  Copyright © 2016 Marko Hlebar. All rights reserved.
//

import Foundation

public protocol View: class {
    
    var viewModel: ViewModeling? { get set }
    func updateBindings(viewModel: ViewModeling?)
}

private var ViewKey: UInt8 = 0
public extension View {
    
    var viewModel: ViewModeling? {
        get {
            let associated = objc_getAssociatedObject(self,  &ViewKey)
            return associated as? ViewModeling
        }
        set {
            objc_setAssociatedObject(self, &ViewKey, newValue as! AnyObject,
                                     .OBJC_ASSOCIATION_RETAIN)
            updateBindings(newValue)
        }
    }
    
    func updateBindings(viewModel: ViewModeling?) {}
}

public protocol CollectionViewable: View {
    
    var collectionViewModel: CollectionViewModel? { get set }
}

public extension CollectionViewable {
    
    var collectionViewModel: CollectionViewModel? {
        get {
            return viewModel as? CollectionViewModel
        }
        set {
            viewModel = newValue
        }
    }
    
    func cellAt(indexPath: NSIndexPath) -> CellViewModel? {
        return collectionViewModel?.sections[indexPath.section].cells[indexPath.row]
    }
}
