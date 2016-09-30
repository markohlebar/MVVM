//
//  CollectionViewModel.swift
//  Pods
//
//  Created by Marko Hlebar on 30/09/2016.
//
//

import UIKit

open class CollectionViewModel: NSObject, ItemsViewModeling {
    
    public weak var viewModelable: ViewModelable?
    public var sections: [SectionViewModeling]!
    
    open func didSelectCell(_ cell: CellViewModeling) -> Bool {
        return true
    }
    
    open func didDeleteCell(_ cell: CellViewModeling) {}
    
    open func canEditCell(_ cell: CellViewModeling) -> Bool {
        return false
    }
}
