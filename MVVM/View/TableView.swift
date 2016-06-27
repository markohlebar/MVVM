//
//  TableView.swift
//  GIFMash
//
//  Created by Marko Hlebar on 19/06/2016.
//  Copyright © 2016 Marko Hlebar. All rights reserved.
//

import UIKit

public class TableView: UITableView, UITableViewDelegate, UITableViewDataSource, CollectionViewModelable {
        
    public var didSelectCell: (TableCellViewModeling -> Void)?
    
    public override init(frame: CGRect, style:UITableViewStyle) {
        super.init(frame: frame, style: style)
        
        self.delegate = self
        self.dataSource = self
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.delegate = self
        self.dataSource = self
    }
    
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        guard let tableViewModel = collectionViewModel else {
            return 0
        }
        return tableViewModel.sections.count
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let tableViewModel = collectionViewModel else {
            return 0
        }
        return tableViewModel.sections[section].cells.count
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let tableViewModel = collectionViewModel else {
            return UITableViewCell()
        }
        
        let rowViewModel = cellAt(indexPath)!
        
        tableView.registerClass(rowViewModel.viewClass, forCellReuseIdentifier: (rowViewModel.cellIdentifier))
        
        let cell = tableView.dequeueReusableCellWithIdentifier((rowViewModel.cellIdentifier), forIndexPath: indexPath) as! ViewModelable
        
        cell.viewModel = rowViewModel
        
        return cell as! UITableViewCell
    }
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard collectionViewModel != nil  else {
            return
        }

        if collectionViewModel!.didSelectCell(cellAt(indexPath) as! TableCellViewModeling) {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }
}
