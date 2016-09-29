//
//  TableView.swift
//  GIFMash
//
//  Created by Marko Hlebar on 19/06/2016.
//  Copyright © 2016 Marko Hlebar. All rights reserved.
//

import UIKit

open class TableView: UITableView, UITableViewDelegate, UITableViewDataSource, CollectionViewModelable {
            
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
    
    open func numberOfSections(in tableView: UITableView) -> Int {
        guard let tableViewModel = collectionViewModel else {
            return 0
        }
        return tableViewModel.sections.count
    }
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let tableViewModel = collectionViewModel else {
            return 0
        }
        return tableViewModel.sections[section].cells.count
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard collectionViewModel != nil else {
            return UITableViewCell()
        }
        
        let rowViewModel = cellAt(indexPath)!
        
        if let nibName = rowViewModel.nibName {
            let nib = UINib.init(nibName: nibName, bundle: Bundle.main)
            tableView.register(nib, forCellReuseIdentifier:rowViewModel.cellIdentifier)
        }
        else if let viewClass = rowViewModel.viewClass {
            tableView.register(viewClass, forCellReuseIdentifier:rowViewModel.cellIdentifier)
        }
        else {
            //TODO: throw exception with MVVM domain
        }
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: (rowViewModel.cellIdentifier), for: indexPath) as? ViewModelable {
            cell.viewModel = rowViewModel
            return cell as! UITableViewCell
        }
        else {
            assert(false, "The cell is not view modelable; Make sure the cell imlpements ViewModelable protocol.")
        }
        
        return UITableViewCell()
    }
    
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let collectionViewModel = collectionViewModel else {
            return
        }

        if collectionViewModel.didSelectCell(cellAt(indexPath) as! TableCellViewModeling) {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let rowViewModel = cellAt(indexPath) as! TableCellViewModeling
        return rowViewModel.cellHeight
    }
    
    open func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        guard let collectionViewModel = collectionViewModel else {
            return false
        }
        
        return collectionViewModel.canEditCell(cellAt(indexPath) as! TableCellViewModeling)
    }
    
    open func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        guard let collectionViewModel = collectionViewModel else {
            return
        }
        
        switch editingStyle {
            case .delete:
                collectionViewModel.didDeleteCell(cellAt(indexPath) as! TableCellViewModeling)
            case .insert: break

            default: break
        }
    }
    
    open func scrollToIndexPath(_ indexPath: IndexPath) {
        self.scrollToRow(at: indexPath, at:.top, animated:true)
    }
}
