//
//  TableView.swift
//  GIFMash
//
//  Created by Marko Hlebar on 19/06/2016.
//  Copyright © 2016 Marko Hlebar. All rights reserved.
//

import UIKit

open class TableView: UITableView, ItemsViewModelable {
    
    public var viewModel: ViewModeling?
    public var updater: ViewUpdating?
    
    public func willRefresh(with viewModel: ViewModeling) {
        if let tableViewModel = viewModel as? TableViewModel {
            self.delegate = tableViewModel
            self.dataSource = tableViewModel
        }
        else {
            assert(false, "Can't assign a view model that is not a TableViewModel")
        }
    }
    
    open func scrollTo(indexPath indexPath: IndexPath) {
        self.scrollToRow(at: indexPath, at:.top, animated:true)
    }
}
