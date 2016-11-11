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
open class TableViewModel: NSObject, TableViewModeling, NSCopying {

    weak public var viewModelable: ViewModelable?
    public var sections: [SectionViewModeling]! = []
    public var header: ViewModeling?
    public var uniqueIdentifier: String

    open func didSelect(cell: CellViewModeling) -> Bool {
        return true
    }
    
    open func didDelete(cell: CellViewModeling) {}
    
    open func canEdit(cell: CellViewModeling) -> Bool {
        return false
    }

    open func copy(with zone: NSZone? = nil) -> Any {
        let viewModel = type(of: self).init()
        viewModel.viewModelable = viewModelable
        viewModel.sections = sections
        viewModel.header = header
        return viewModel
    }

    public required override init() {
        uniqueIdentifier = ""
        super.init()
    }
}

extension TableViewModel: UITableViewDataSource {
    open func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].cells.count
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
            assert(false, "The cell is not view modelable; Make sure the cell implements ViewModelable protocol.")
        }
        
        return UITableViewCell()
    }

    open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionViewModel = sections[section]

        guard let header = sectionViewModel.header else {
            return nil
        }

        if let nibName = header.nibName {
            let nib = UINib.init(nibName: nibName, bundle: Bundle.main)
            tableView.register(nib, forHeaderFooterViewReuseIdentifier: header.cellIdentifier)
        }
        else if let viewClass = header.viewClass {
            tableView.register(viewClass, forHeaderFooterViewReuseIdentifier: header.cellIdentifier)
        }
        else {
            //TODO: throw exception with MVVM domain
        }

        if let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: header.cellIdentifier) as? ViewModelable{
            view.refresh(with: header)

            let uiView = view as! UIView
            return uiView
        }
        else {
            assert(false, "The header view is not view modelable; Make sure the header view implements ViewModelable protocol.")
        }

        return nil
    }

    open func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let sectionViewModel = sections[section]

        guard let header = sectionViewModel.header as? TableCellViewModeling else {
            return 0
        }

        return header.cellHeight
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
