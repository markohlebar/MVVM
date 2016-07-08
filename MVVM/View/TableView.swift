//
//  TableView.swift
//  GIFMash
//
//  Created by Marko Hlebar on 19/06/2016.
//  Copyright © 2016 Marko Hlebar. All rights reserved.
//

import UIKit

public class TableView: UITableView, UITableViewDelegate, UITableViewDataSource, CollectionViewModelable {
            
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
        
        if let nibName = rowViewModel.nibName {
            let nib = UINib.init(nibName: nibName, bundle: NSBundle.mainBundle())
            tableView.registerNib(nib, forCellReuseIdentifier:rowViewModel.cellIdentifier)
        }
        else if let viewClass = rowViewModel.viewClass {
            tableView.registerClass(viewClass, forCellReuseIdentifier:rowViewModel.cellIdentifier)
        }
        else {
            //TODO: throw exception with MVVM domain
        }
        
        if let cell = tableView.dequeueReusableCellWithIdentifier((rowViewModel.cellIdentifier), forIndexPath: indexPath) as? ViewModelable {
            cell.viewModel = rowViewModel
            return cell as! UITableViewCell
        }
        else {
            assert(false, "The cell is not view modelable; Make sure the cell imlpements ViewModelable protocol.")
        }
        
        return UITableViewCell()
    }
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard let collectionViewModel = collectionViewModel else {
            return
        }

        if collectionViewModel.didSelectCell(cellAt(indexPath) as! TableCellViewModeling) {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }
    
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let rowViewModel = cellAt(indexPath) as! TableCellViewModeling
        return rowViewModel.cellHeight
    }
    
    public func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        guard let collectionViewModel = collectionViewModel else {
            return false
        }
        
        return collectionViewModel.canEditCell(cellAt(indexPath) as! TableCellViewModeling)
    }
    
    public func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        guard let collectionViewModel = collectionViewModel else {
            return
        }
        
        switch editingStyle {
            case .Delete:
                collectionViewModel.didDeleteCell(cellAt(indexPath) as! TableCellViewModeling)
            case .Insert: break

            default: break
        }
    }
    
    public func scrollToIndexPath(indexPath: NSIndexPath) {
        self.scrollToRowAtIndexPath(indexPath, atScrollPosition:.Top, animated:true)
    }
}
