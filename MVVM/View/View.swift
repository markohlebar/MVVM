//
//  View.swift
//  GIFMash
//
//  Created by Marko Hlebar on 17/06/2016.
//  Copyright © 2016 Marko Hlebar. All rights reserved.
//

import Foundation

public protocol View: class {
    
    var viewModel: ViewModelProtocol? { get set }
    func updateBindings(viewModel: ViewModelProtocol?)
}

private var ViewKey: UInt8 = 0
public extension View {
    
    var viewModel: ViewModelProtocol? {
        get {
            let associated = objc_getAssociatedObject(self,  &ViewKey)
            return associated as? ViewModelProtocol
        }
        set {
            objc_setAssociatedObject(self, &ViewKey, newValue as! AnyObject,
                                     .OBJC_ASSOCIATION_RETAIN)
            updateBindings(newValue)
        }
    }
    
    func updateBindings(viewModel: ViewModelProtocol?) {}
}