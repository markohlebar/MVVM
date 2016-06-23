//
//  CollectionView.swift
//  Pods
//
//  Created by Marko Hlebar on 22/06/2016.
//
//

import UIKit

//public class CollectionViewColl: UICollectionViewCell, View {
//    
//    public func updateBindings(viewModel: ViewModeling?) {}
//}

public class CollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, View {
    
//    var collectionViewModel: CollectionViewModel? {
//        get {
//            return viewModel as? CollectionViewModel
//        }
//    }
    
    public override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        self.delegate = self
        self.dataSource = self
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.delegate = self
        self.dataSource = self
    }
    
    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    
//    public var didSelectItem: (CollectionItemViewModel -> Void)?
//    
//    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        guard let collectionViewModel = collectionViewModel else {
//            return 0
//        }
//        return collectionViewModel.sections.count
//    }
//    
//    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        guard let collectionViewModel = collectionViewModel else {
//            return 0
//        }
//        return collectionViewModel.sections[section].rows.count
//    }
//    
//    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        guard let collectionViewModel = collectionViewModel else {
//            return CollectionViewCell()
//        }
//        
//        let sectionViewModel = collectionViewModel.sections[indexPath.section]
//        let rows = sectionViewModel.rows
//        let rowViewModel = rows[indexPath.row]
//        
//        tableView.registerClass(rowViewModel.viewClass(), forCellReuseIdentifier: (rowViewModel.cellIdentifier))
//        
//        let cell = tableView.dequeueReusableCellWithIdentifier((rowViewModel.cellIdentifier), forIndexPath: indexPath) as! TableViewCell
//        
//        cell.viewModel = rowViewModel
//        
//        return cell
//    }
//    
//    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        tableView.deselectRowAtIndexPath(indexPath, animated: true)
//        
//        guard let tableViewModel = tableViewModel else {
//            return
//        }
//        
//        if let didSelectRow = didSelectRow {
//            let row = tableViewModel.sections[indexPath.section].rows[indexPath.row]
//            didSelectRow(row)
//        }
//    }
}
