//
//  CollectionView.swift
//  Pods
//
//  Created by Marko Hlebar on 22/06/2016.
//
//

#if os(iOS) || os(tvOS)
    
import UIKit

open class CollectionView: UICollectionView, ItemsViewModelable {
    
    public var viewModel: ViewModeling?
    public var updater: ViewUpdating?
    
    public func willRefresh(with viewModel: ViewModeling) {
        if let collectionViewModel = viewModel as? CollectionViewModel {
            self.delegate = collectionViewModel
            self.dataSource = collectionViewModel
        }
        else {
            assert(false, "Can't assign a view model that is not a CollectionViewModel")
        }
    }
    
    open func scrollTo(indexPath indexPath: IndexPath) {
        self.scrollToItem(at: indexPath, at:.top, animated:true)        
    }
}
    
#endif
