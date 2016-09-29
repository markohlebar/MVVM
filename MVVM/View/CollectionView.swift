//
//  CollectionView.swift
//  Pods
//
//  Created by Marko Hlebar on 22/06/2016.
//
//

import UIKit

open class CollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, CollectionViewModelable {
        
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
    
    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard let collectionViewModel = collectionViewModel else {
            return 0
        }
        return collectionViewModel.sections.count
    }
    
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let collectionViewModel = collectionViewModel else {
            return 0
        }
        return collectionViewModel.sections[section].cells.count
    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard collectionViewModel != nil else {
            return UICollectionViewCell()
        }
        
        let cellViewModel = cellAt(indexPath)!
        
        collectionView.register(cellViewModel.viewClass, forCellWithReuseIdentifier: (cellViewModel.cellIdentifier))
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellViewModel.cellIdentifier, for: indexPath) as! ViewModelable
        
        cell.viewModel = cellViewModel
                
        return cell as! UICollectionViewCell
    }
    
    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let collectionViewModel = collectionViewModel else {
            return
        }
        
        if collectionViewModel.didSelectCell(cellAt(indexPath) as!CollectionCellViewModeling) {
            collectionView.deselectItem(at: indexPath, animated: true)
        }
    }
    
    open func collectionView(_ collectionView: UICollectionView,
                          layout collectionViewLayout: UICollectionViewLayout,
                                 sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cell = cellAt(indexPath) as! CollectionCellViewModeling
        return cell.cellSize
    }
    
    open func scrollToIndexPath(_ indexPath: IndexPath) {
        self.scrollToItem(at: indexPath, at:.top, animated:true)        
    }
}
