//
//  CollectionView.swift
//  Pods
//
//  Created by Marko Hlebar on 22/06/2016.
//
//

import UIKit

public class CollectionViewCell: UICollectionViewCell, ViewModelable {
    
    public func updateBindings(viewModel: ViewModeling?) {}
}

public class CollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, CollectionViewModelable {
    
    public var didSelectCell: (CollectionCellViewModeling -> Void)?
    
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
    
    public func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        guard let collectionViewModel = collectionViewModel else {
            return 0
        }
        return collectionViewModel.sections.count
    }
    
    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let collectionViewModel = collectionViewModel else {
            return 0
        }
        return collectionViewModel.sections[section].cells.count
    }
    
    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        guard let collectionViewModel = collectionViewModel else {
            return CollectionViewCell()
        }
        
        let cellViewModel = cellAt(indexPath)!
        
        collectionView.registerClass(cellViewModel.viewClass, forCellWithReuseIdentifier: (cellViewModel.cellIdentifier))
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellViewModel.cellIdentifier, forIndexPath: indexPath) as! CollectionViewCell
        
        cell.viewModel = cellViewModel
                
        return cell
    }
    
    public func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
        
        guard let collectionViewModel = collectionViewModel else {
            return
        }
        
        if let didSelectCell = didSelectCell {
            didSelectCell(cellAt(indexPath) as! CollectionCellViewModeling)
        }
    }
}
