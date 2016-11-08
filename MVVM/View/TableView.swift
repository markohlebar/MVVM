//
//  TableView.swift
//  GIFMash
//
//  Created by Marko Hlebar on 19/06/2016.
//  Copyright © 2016 Marko Hlebar. All rights reserved.
//

#if os(iOS) || os(tvOS)
    
import UIKit

    func objectFrom(class aClass: AnyClass) -> NSObject {
        let anyobjectype : AnyObject.Type = aClass
        let nsobjectype : NSObject.Type = anyobjectype as! NSObject.Type
        return nsobjectype.init()
    }

    extension UIView {
        class func load(withNibNamed nibNamed: String) -> UIView? {
            let objects = Bundle.main.loadNibNamed(nibNamed, owner: self, options: nil)
            return objects?.first as? UIView
        }

        class func load(withClass aClass: AnyClass) -> UIView {
            return objectFrom(class: aClass) as! UIView
        }
    }

open class TableView: UITableView, ItemsViewModelable {
    
    public var viewModel: ViewModeling?
    public var updater: ViewUpdating?
    
    public func willRefresh(with viewModel: ViewModeling) {
        guard viewModel is TableViewModel else {
            assert(false, "Can't assign a view model that is not a TableViewModel")
        }

        let tableViewModel = viewModel as! TableViewModel

        self.delegate = tableViewModel
        self.dataSource = tableViewModel

        if let header = tableViewModel.header {
            if let viewClass = header.viewClass {
                tableHeaderView = UIView.load(withClass: viewClass)
            }
            else if let nibName = header.nibName {
                tableHeaderView = UIView.load(withNibNamed: nibName)
            }
            else {
                assert(false, "Can't find viewClass or nibName for the UITableViewHeader")
            }

            if let viewModelable = tableHeaderView as? ViewModelable {
                viewModelable.refresh(with: header)
            }
            else {
                assert(false, "TableHeaderView is not ViewModelable")
            }
        }
    }

    open func scrollTo(indexPath: IndexPath) {
        self.scrollToRow(at: indexPath, at:.top, animated:true)
    }

}
    
#endif
