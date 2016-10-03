//
//  ViewModel.swift
//  GIFMash
//
//  Created by Marko Hlebar on 08/06/2016.
//  Copyright © 2016 Marko Hlebar. All rights reserved.
//

import Foundation
import CoreGraphics

public protocol ViewModeling {
    
    var uniqueIdentifier: String { get }
    var viewClass: AnyClass? { get }
    var nibName: String? { get }
    weak var viewModelable: ViewModelable? {get set}
    func refresh()
}

public extension ViewModeling {
    
    public var viewClass: AnyClass? {
        return nil
    }
    
    //TODO: this makes it hard to debug if the client implements non optional var nibName
    public var nibName: String? {
        return nil
    }
    
    public func refresh() {
        self.viewModelable?.refresh(with: self)
    }
}

//TODO: Is this really the best way to check equality between objects implementing a protocol?
public func ==(lhs: ViewModeling, rhs: ViewModeling) -> Bool {
    return lhs.uniqueIdentifier == rhs.uniqueIdentifier
}

public func !=(lhs: ViewModeling, rhs: ViewModeling) -> Bool {
    return lhs.uniqueIdentifier != rhs.uniqueIdentifier
}

