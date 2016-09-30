//
//  CollectionViewModeling.swift
//  Pods
//
//  Created by Marko Hlebar on 30/09/2016.
//
//

public protocol CollectionCellViewModeling: CellViewModeling {
    
    var cellSize: CGSize { get }
}

public extension CollectionCellViewModeling {
    
    public var cellSize: CGSize {
        return CGSize(width: 44, height: 44)
    }
}
