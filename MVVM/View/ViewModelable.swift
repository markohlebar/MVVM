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
    //Bypassing equality check will rerender the model by not checking if the same view model is already rendered.
    func refresh(with viewModel: ViewModeling, bypassingEqualityCheck: Bool)

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
        refresh(with: viewModel, bypassingEqualityCheck: false)
    }

    //For some reason defining bypassingEqualityCheck = false as a default parameter doesn't work, 
    //hence 2 functions are exposed instead.
    public func refresh(with viewModel: ViewModeling, bypassingEqualityCheck: Bool) {
        if !bypassingEqualityCheck, let oldViewModel = self.viewModel,
            oldViewModel == viewModel {
            return
        }

        willRefresh(with: viewModel)
        _refresh(with: viewModel)
        didRefresh(with: viewModel)
    }
    
    public func willRefresh(with viewModel: ViewModeling) {}

    public func didRefresh(with viewModel: ViewModeling) {}

    //Can't extend internal functions!
    internal func _refresh(with viewModel: ViewModeling) {
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

    public func refresh(with viewModel: ViewModeling, bypassingEqualityCheck: Bool) {
        willRefresh(with: viewModel)
        _refresh(with: viewModel)
        updater?.update(with: viewModel)
        didRefresh(with: viewModel)
    }
    
    func cellAt(indexPath: IndexPath) -> CellViewModeling? {
        return itemsViewModel?.sections[(indexPath as NSIndexPath).section].cells[(indexPath as NSIndexPath).row]
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
