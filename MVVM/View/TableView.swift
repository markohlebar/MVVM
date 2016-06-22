//
//  TableView.swift
//  GIFMash
//
//  Created by Marko Hlebar on 19/06/2016.
//  Copyright © 2016 Marko Hlebar. All rights reserved.
//

import UIKit

public class TableViewCell: UITableViewCell, View {
    
    public func updateBindings(viewModel: ViewModelProtocol?) {}
}

public class TableView: UITableView, UITableViewDelegate, UITableViewDataSource, View {
    
    var tableViewModel: TableViewModel? {
        get {
            return viewModel as? TableViewModel
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.delegate = self
        self.dataSource = self
    }
    
    public var didSelectRow: (TableRowViewModel -> Void)?
    
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        guard let tableViewModel = tableViewModel else {
            return 0
        }
        return tableViewModel.sections.count
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let tableViewModel = tableViewModel else {
            return 0
        }
        return tableViewModel.sections[section].rows.count
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let tableViewModel = tableViewModel else {
            return UITableViewCell()
        }
        
        let sectionViewModel = tableViewModel.sections[indexPath.section]
        let rows = sectionViewModel.rows
        let rowViewModel = rows[indexPath.row]
        
        tableView.registerClass(rowViewModel.viewClass(), forCellReuseIdentifier: (rowViewModel.cellIdentifier))
        
        let cell = tableView.dequeueReusableCellWithIdentifier((rowViewModel.cellIdentifier), forIndexPath: indexPath) as! TableViewCell
        
        cell.viewModel = rowViewModel
        
        return cell
    }
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        guard let tableViewModel = tableViewModel else {
            return
        }

        if let didSelectRow = didSelectRow {
            let row = tableViewModel.sections[indexPath.section].rows[indexPath.row]
            didSelectRow(row)
        }
    }
}
