//
//  TableViewModeling.swift
//  Pods
//
//  Created by Marko Hlebar on 30/09/2016.
//
//

import CoreGraphics

public protocol TableCellViewModeling: CellViewModeling {
    
    var cellHeight: CGFloat { get }
}

public extension TableCellViewModeling {
    
    public var cellHeight: CGFloat {
        return 44
    }
}
