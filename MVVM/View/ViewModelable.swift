//
//  View.swift
//  GIFMash
//
//  Created by Marko Hlebar on 17/06/2016.
//  Copyright © 2016 Marko Hlebar. All rights reserved.
//

import Foundation

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

private func getAssociatedObject(object: AnyObject, associativeKey: UnsafePointer<Void>) -> ViewModeling? {
    if let v = objc_getAssociatedObject(object, associativeKey) as? ViewModeling {
        return v
    }
    else if let v = objc_getAssociatedObject(object, associativeKey) as? Lifted<ViewModeling> {
        return v.value
    }
    else {
        return nil
    }
}

public protocol ViewModelable: class {
    
    var viewModel: ViewModeling? { get set }
    func updateBindings(viewModel: ViewModeling?)
}

private var ViewKey: UInt8 = 0
public extension ViewModelable {
    
    var viewModel: ViewModeling? {
        get {
            let associated = getAssociatedObject(self, associativeKey: &ViewKey)
            return associated
        }
        set {
            setAssociatedObject(self, value: newValue, associativeKey: &ViewKey, policy: .OBJC_ASSOCIATION_RETAIN)
            updateBindings(newValue)
        }
    }
    
    func updateBindings(viewModel: ViewModeling?) {}
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
