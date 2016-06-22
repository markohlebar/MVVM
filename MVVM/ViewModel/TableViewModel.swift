//
//  TableViewModel.swift
//  GIFMash
//
//  Created by Marko Hlebar on 15/06/2016.
//  Copyright © 2016 Marko Hlebar. All rights reserved.
//

import Foundation
import UIKit

/// Convenience handler to reload the table view on every change.
public struct TableViewReloadHandler: ViewUpdateHandler {
    
    let tableView: UITableView
    
    public init(tableView: UITableView) {
        self.tableView = tableView
    }
    
    public func updateWithViewModel(viewModel: ViewModelProtocol) {
        self.tableView.reloadData()
    }
}

public class TableViewModel: ViewModelProtocol {
    
    public var sections: [TableSectionViewModel]
    let updateHandler: ViewUpdateHandler
    
    public required init(updateHandler: ViewUpdateHandler) {
        self.updateHandler = updateHandler
        sections = []
        reload()
    }
    
    public func reload() {
        updateHandler.updateWithViewModel(self)
    }
    
    public func viewClass() -> AnyClass {
        return TableView.self
    }
    
    public func uniqueIdentifier() -> String {
        return ""
    }
}

public class TableSectionViewModel: ViewModelProtocol {

    public let rows: [TableRowViewModel]
    
    public required init(rows: [TableRowViewModel]) {
        self.rows = rows
    }
    
    public func viewClass() -> AnyClass {
        return UIView.self
    }
    
    public func uniqueIdentifier() -> String {
        return ""
    }
}

public class TableRowViewModel: ViewModelProtocol {
    
    lazy var cellIdentifier: String = {
        return NSStringFromClass(self.viewClass())
    }()
    
    public init() {}
    
    public func viewClass() -> AnyClass {
        return UITableViewCell.self
    }
    
    public func uniqueIdentifier() -> String {
        return ""
    }
    
    func cellHeight() -> CGFloat {
        return 44
    }
}
