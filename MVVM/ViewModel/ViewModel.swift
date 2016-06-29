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
    var viewClass: AnyClass { get }
    var refreshHandler: (ViewModeling -> Void)? {get set}
    func refresh()
}

public extension ViewModeling {
    
    public var uniqueIdentifier: String {
        assert(false, "Override uniqueIdentifier in your ViewModel subclass")
        return ""
    }
    
    public var viewClass: AnyClass {
        assert(false, "Override viewClass in your ViewModel subclass")
        return UIView.self
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
    func didSelectCell(cell: CellViewModeling) -> Bool
}

public typealias TableViewModeling = CollectionViewModeling
public extension CollectionViewModeling {
    
    func didSelectCell(cell: CellViewModeling) -> Bool {
        return true
    }
}

public protocol SectionViewModeling: ViewModeling {
    
    var cells: [CellViewModeling] { get set }
}

public struct SectionViewModel: SectionViewModeling {
    public var refreshHandler: (ViewModeling -> Void)?
    public var cells: [CellViewModeling]
    
    public init(cells: [CellViewModeling]) {
        self.cells = cells
    }
}

public protocol CellViewModeling: ViewModeling {
    
    var cellIdentifier: String { get }
}

public extension CellViewModeling {
    
    var cellIdentifier: String {
        return NSStringFromClass(self.viewClass)
    }
}

public protocol CollectionCellViewModeling: CellViewModeling {
    
    var cellSize: CGSize { get }
}

public extension CollectionCellViewModeling {
    
    public var cellSize: CGSize {
        return CGSizeMake(44, 44)
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
