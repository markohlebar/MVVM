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
    
    //Call refresh on the viewModelable to rerender with the new view model.
    func refresh(with viewModel: ViewModeling)
    
    //didRefresh is called after refresh. 
    //Use this to add additional behavior after refresh.
    func didRefresh(with viewModel: ViewModeling)
    
    //didRefresh is called after refresh.
    //Use this to add additional behavior after refresh.
    func willRefresh(with viewModel: ViewModeling)
}

private var ViewModelKey: UInt8 = 0
private var ViewUpdaterKey: UInt8 = 0

public extension ViewModelable {
    
    public func refresh(with viewModel: ViewModeling) {
        willRefresh(with: viewModel)
        _refresh(with: viewModel)
        didRefresh(with: viewModel)
    }
    
    public func willRefresh(with viewModel: ViewModeling) {}

    public func didRefresh(with viewModel: ViewModeling) {}

    internal func _refresh(with viewModel: ViewModeling) {
        if (self.viewModel != nil && self.viewModel! == viewModel) {
            return
        }
        
        self.viewModel = viewModel
        self.viewModel?.viewModelable = self
    }
}

public protocol ItemsViewModelable: ViewModelable {
    
    var updater: ViewUpdating? { get set }
    
    var itemsViewModel: ItemsViewModeling? { get set }
    
    /**
     Implement this behaviour to be able to scroll to cell.
     
     - parameter indexPath: an indexPath to scroll to.
     */
    func scrollTo(indexPath: IndexPath);
}

public extension ItemsViewModelable {
    
    var itemsViewModel: ItemsViewModeling? {
        get {
            return viewModel as? ItemsViewModeling
        }
        set {
            viewModel = newValue!
        }
    }
    
    func cellAt(indexPath: IndexPath) -> CellViewModeling? {
        return itemsViewModel?.sections[(indexPath as NSIndexPath).section].cells[(indexPath as NSIndexPath).row]
    }
    
    public func refresh(with viewModel: ViewModeling) {
        willRefresh(with: viewModel)
        _refresh(with: viewModel)
        self.updater?.update(with: viewModel)
        didRefresh(with: viewModel);
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
            viewModel = newValue!
        }
    }
}
