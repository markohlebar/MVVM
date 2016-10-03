//
//  TableViewModel.swift
//  Pods
//
//  Created by Marko Hlebar on 30/09/2016.
//
//

#if os(iOS) || os(tvOS)

import UIKit

/**
 TableViewModel
 
 A table view model base class, to be used when modeling a TableView.
 */
open class TableViewModel: NSObject, ItemsViewModeling {
    
    open var uniqueIdentifier: String {
        assert(false)
        return ""
    }

    weak public var viewModelable: ViewModelable?
    public var sections: [SectionViewModeling]! = []
    
    open func didSelect(cell cell: CellViewModeling) -> Bool {
        return true
    }
    
    open func didDelete(cell cell: CellViewModeling) {}
    
    open func canEdit(cell cell: CellViewModeling) -> Bool {
        return false
    }
}

extension TableViewModel: UITableViewDataSource {
    open func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sections[section].cells.count
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rowViewModel = cellAt(indexPath: indexPath)!
        
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
            cell.refresh(with: rowViewModel)
            return cell as! UITableViewCell
        }
        else {
            assert(false, "The cell is not view modelable; Make sure the cell imlpements ViewModelable protocol.")
        }
        
        return UITableViewCell()
    }
}

extension TableViewModel: UITableViewDelegate {
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.didSelect(cell: cellAt(indexPath: indexPath) as! TableCellViewModeling) {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let rowViewModel = cellAt(indexPath: indexPath) as! TableCellViewModeling
        return rowViewModel.cellHeight
    }
    
    @objc(tableView:canEditRowAtIndexPath:) open func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return self.canEdit(cell: cellAt(indexPath: indexPath) as! TableCellViewModeling)
    }
    
    @objc(tableView:commitEditingStyle:forRowAtIndexPath:) open func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            self.didDelete(cell: cellAt(indexPath: indexPath) as! TableCellViewModeling)
        case .insert: break
            
        default: break
        }
    }
}

#endif
