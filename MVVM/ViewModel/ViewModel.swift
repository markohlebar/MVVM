//
//  ViewModel.swift
//  GIFMash
//
//  Created by Marko Hlebar on 08/06/2016.
//  Copyright © 2016 Marko Hlebar. All rights reserved.
//

import Foundation
import UIKit

public protocol ViewModeling {
    
    var uniqueIdentifier: String { get }
    var viewClass: AnyClass? { get }
    var nibName: String? { get }
    var refreshHandler: ((ViewModeling) -> Void)? {get set}
    weak var viewModelable: ViewModelable? {get set}
    func refresh()
}

public extension ViewModeling {
    
    public var uniqueIdentifier: String {
        //TODO: Throw exception rather than assert? 
        assert(false, "Override uniqueIdentifier in your ViewModel subclass")
        return ""
    }
    
    public var viewClass: AnyClass? {
        return nil
    }
    
    //TODO: this makes it hard to debug if the client implements non optional var nibName
    public var nibName: String? {
        return nil
    }
    
    public func refresh() {
        refreshHandler!(self)
    }
}

public protocol CollectionViewModeling: ViewModeling {
    
    var sections: [SectionViewModeling]! { get set }
    
    /**
     Invoked when a cell is tapped.
     
     - parameter cell: a cell view model for the cell that was selected.
     
     - returns: should it deselect animated?
     */
    func didSelectCell(_ cell: CellViewModeling) -> Bool
    
    /**
     Invoked when a cell is deleted.
     
     - parameter cell: a cell view model for the cell that was deleted.
     */
    func didDeleteCell(_ cell: CellViewModeling)
    
    /**
     Invoked when a cell is asked to be edited.
     
     - parameter cell:  cell view model for the cell that needs to be edited.
     
     - returns: can it be edited?
     */
    func canEditCell(_ cell: CellViewModeling) -> Bool
}

public typealias TableViewModeling = CollectionViewModeling
public extension CollectionViewModeling {
    
    func didSelectCell(_ cell: CellViewModeling) -> Bool {
        return true
    }
    
    func didDeleteCell(_ cell: CellViewModeling) {}
    
    func canEditCell(_ cell: CellViewModeling) -> Bool {
        return false
    }
}

public protocol SectionViewModeling: ViewModeling {
    
    var cells: [CellViewModeling] { get set }
}

public struct SectionViewModel: SectionViewModeling {
    public var refreshHandler: ((ViewModeling) -> Void)?
    public var cells: [CellViewModeling]
    public weak var viewModelable: ViewModelable?
    
    public init(cells: [CellViewModeling]) {
        self.cells = cells
    }
}

public protocol CellViewModeling: ViewModeling {
    
    var cellIdentifier: String { get }
}

public extension CellViewModeling {
    
    var cellIdentifier: String {
        if let nibName = self.nibName {
            return nibName
        }
        else if let viewClass = self.viewClass {
            return NSStringFromClass(viewClass)
        }
        
        //TODO: Throw exception here?
        return ""
    }
}

public protocol CollectionCellViewModeling: CellViewModeling {
    
    var cellSize: CGSize { get }
}

public extension CollectionCellViewModeling {
    
    public var cellSize: CGSize {
        return CGSize(width: 44, height: 44)
    }
}

public protocol TableCellViewModeling: CellViewModeling {
    
    var cellHeight: CGFloat { get }
}

public extension TableCellViewModeling {
    
    public var cellHeight: CGFloat {
        return 44
    }
}
