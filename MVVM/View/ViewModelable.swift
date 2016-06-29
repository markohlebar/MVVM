//
//  View.swift
//  GIFMash
//
//  Created by Marko Hlebar on 17/06/2016.
//  Copyright © 2016 Marko Hlebar. All rights reserved.
//

import Foundation

public protocol ViewModelable: class {
    var viewModel: ViewModeling? { get set }
    var updater: ViewUpdating? { get set }
    func updateBindings(viewModel: ViewModeling)
}

private var ViewModelKey: UInt8 = 0
private var ViewUpdaterKey: UInt8 = 0

public extension ViewModelable {

    var viewModel: ViewModeling? {
        get {
            let associated: ViewModeling? = getAssociatedObject(self, associativeKey: &ViewModelKey)
            return associated
        }
        set {
            setAssociatedObject(self, value: newValue, associativeKey: &ViewModelKey, policy: .OBJC_ASSOCIATION_RETAIN)
            
            if var viewModel = newValue {
                updateBindings(viewModel)
                
                if let updater = updater {
                    viewModel.refreshHandler = updater.updateWithViewModel
                }
            }
        }
    }
    
    var updater: ViewUpdating? {
        get {
            let associated: ViewUpdating? = getAssociatedObject(self, associativeKey: &ViewUpdaterKey)
            return associated
        }
        set {
          setAssociatedObject(self, value: newValue, associativeKey: &ViewUpdaterKey, policy: .OBJC_ASSOCIATION_RETAIN)
            
            if var viewModel = viewModel {
                viewModel.refreshHandler = newValue!.updateWithViewModel
                viewModel.refresh()
            }
        }
    }
    
    public func updateBindings(viewModel: ViewModeling) {}
}

public protocol CollectionViewModelable: ViewModelable {
    
    var collectionViewModel: CollectionViewModeling? { get set }
}

public extension CollectionViewModelable {
    
    var collectionViewModel: CollectionViewModeling? {
        get {
            return viewModel as? CollectionViewModeling
        }
        set {
            viewModel = newValue
        }
    }
    
    func cellAt(indexPath: NSIndexPath) -> CellViewModeling? {
        return collectionViewModel?.sections[indexPath.section].cells[indexPath.row]
    }
}

public protocol CellViewModelable: ViewModelable {
    
    var cellViewModel: CellViewModeling? { get set }
}

public extension CellViewModelable {
    
    var cellViewModel: CellViewModeling? {
        get {
            return viewModel as? CellViewModeling
        }
        set {
            viewModel = newValue
        }
    }
}

// MARK: - Associated object functions

//http://stackoverflow.com/questions/24133058/is-there-a-way-to-set-associated-objects-in-swift
final class Lifted<T> {
    let value: T
    init(_ x: T) {
        value = x
    }
}

private func lift<T>(x: T) -> Lifted<T>  {
    return Lifted(x)
}

private func setAssociatedObject<T>(object: AnyObject, value: T, associativeKey: UnsafePointer<Void>, policy: objc_AssociationPolicy) {
    if let v: AnyObject = value as? AnyObject {
        objc_setAssociatedObject(object, associativeKey, v,  policy)
    }
    else {
        objc_setAssociatedObject(object, associativeKey, lift(value),  policy)
    }
}

private func getAssociatedObject<T>(object: AnyObject, associativeKey: UnsafePointer<Void>) -> T? {
    if let v = objc_getAssociatedObject(object, associativeKey) as? T {
        return v
    }
    else if let v = objc_getAssociatedObject(object, associativeKey) as? Lifted<T> {
        return v.value
    }
    else {
        return nil
    }
}
