//
//  CollectionView.swift
//  Pods
//
//  Created by Marko Hlebar on 22/06/2016.
//
//

import UIKit

public class CollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, CollectionViewModelable {
    
    public var didSelectCell: (CollectionCellViewModeling -> Void)?
    
    public override init(frame frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
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
            return UICollectionViewCell()
        }
        
        let cellViewModel = cellAt(indexPath)!
        
        collectionView.registerClass(cellViewModel.viewClass, forCellWithReuseIdentifier: (cellViewModel.cellIdentifier))
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellViewModel.cellIdentifier, forIndexPath: indexPath) as! ViewModelable
        
        cell.viewModel = cellViewModel
                
        return cell as! UICollectionViewCell
    }
    
    public func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        guard collectionViewModel != nil else {
            return
        }
        
        if collectionViewModel!.didSelectCell(cellAt(indexPath) as! TableCellViewModeling) {
            collectionView.deselectItemAtIndexPath(indexPath, animated: true)
        }
    }
}
