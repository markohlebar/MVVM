//
//  CollectionViewModel.swift
//  Pods
//
//  Created by Marko Hlebar on 30/09/2016.
//
//

#if os(iOS) || os(tvOS)

import UIKit

open class CollectionViewModel: NSObject, ItemsViewModeling {
    
    open var uniqueIdentifier: String {
        assert(false)
        return ""
    }
    
    public weak var viewModelable: ViewModelable?
    public var sections: [SectionViewModeling]!
    
    open func didSelect(cell cell: CellViewModeling) -> Bool {
        return true
    }
    
    open func didDelete(cell cell: CellViewModeling) {}
    
    open func canEdit(cell cell: CellViewModeling) -> Bool {
        return false
    }
}

extension CollectionViewModel: UICollectionViewDataSource {
    
    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.sections.count
    }
    
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.sections[section].cells.count
    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellViewModel = cellAt(indexPath: indexPath)!
        
        collectionView.register(cellViewModel.viewClass, forCellWithReuseIdentifier: (cellViewModel.cellIdentifier))
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellViewModel.cellIdentifier, for: indexPath) as! ViewModelable
        
        cell.refresh(with: cellViewModel)
        
        return cell as! UICollectionViewCell
    }
}

extension CollectionViewModel: UICollectionViewDelegate {
    
    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.didSelect(cell: cellAt(indexPath: indexPath) as! CollectionCellViewModeling) {
            collectionView.deselectItem(at: indexPath, animated: true)
        }
    }
}

extension CollectionViewModel: UICollectionViewDelegateFlowLayout {
    
    open func collectionView(_ collectionView: UICollectionView,
                             layout collectionViewLayout: UICollectionViewLayout,
                             sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cell = cellAt(indexPath: indexPath) as! CollectionCellViewModeling
        return cell.cellSize
    }
}

#endif
