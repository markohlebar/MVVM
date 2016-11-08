//
//  ListViewModeling.swift
//  Pods
//
//  Created by Marko Hlebar on 30/09/2016.
//
//

import Foundation

//ItemsViewModeling unifies the interfaces for TableViews and CollectionViews
public protocol ItemsViewModeling: ViewModeling {
    
    var sections: [SectionViewModeling]! { get set }
    
    /**
     Invoked when a cell is tapped.
     
     - parameter cell: a cell view model for the cell that was selected.
     
     - returns: should it deselect animated?
     */
    func didSelect(cell: CellViewModeling) -> Bool
    
    /**
     Invoked when a cell is deleted.
     
     - parameter cell: a cell view model for the cell that was deleted.
     */
    func didDelete(cell: CellViewModeling)
    
    /**
     Invoked when a cell is asked to be edited.
     
     - parameter cell:  cell view model for the cell that needs to be edited.
     
     - returns: can it be edited?
     */
    func canEdit(cell: CellViewModeling) -> Bool
    
    
    func cellAt(indexPath: IndexPath) -> CellViewModeling?
}

//TableViewModeling adds
public protocol TableViewModeling: ItemsViewModeling {

    //Describes the Table View Header
    var header: ViewModeling? { get set }
}

public extension ItemsViewModeling {
    
    public func cellAt(indexPath: IndexPath) -> CellViewModeling? {
        return self.sections[(indexPath as NSIndexPath).section].cells[(indexPath as NSIndexPath).row]
    }
    
    public func cells(inSection section:Int) -> [CellViewModeling] {
        guard let sections = self.sections,
                sections.count > section else {
            return [CellViewModeling]()
        }
        
        return self.sections[section].cells
    }
}

public protocol SectionViewModeling: ViewModeling {
    
    var cells: [CellViewModeling] { get set }
    var header: CellViewModeling? { get set }
    var footer: CellViewModeling? { get set }
}

public struct SectionViewModel: SectionViewModeling {
    public var uniqueIdentifier: String = ""

    public var cells: [CellViewModeling]
    public var header: CellViewModeling?
    public var footer: CellViewModeling?

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