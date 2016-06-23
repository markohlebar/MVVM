//
//  ViewModel.swift
//  GIFMash
//
//  Created by Marko Hlebar on 08/06/2016.
//  Copyright © 2016 Marko Hlebar. All rights reserved.
//

import Foundation
import UIKit

public protocol ViewModeling: class {
    
    func uniqueIdentifier() -> String
    func viewClass() -> AnyClass
}

public typealias TableViewModel = CollectionViewModel
public typealias TableSectionViewModel = SectionViewModel

public class ViewModel: ViewModeling {
    
    public init() {}

    public func viewClass() -> AnyClass {
        assert(false, "Override viewClass in your ViewModel subclass")
        return UIView.self
    }
    
    public func uniqueIdentifier() -> String {
        assert(false, "Override uniqueIdentifier in your ViewModel subclass")
        return ""
    }
}

public class CollectionViewModel: ViewModel {
    
    public var sections: [SectionViewModel]
    let updater: ViewUpdating
    
    public required init(updater: ViewUpdating) {
        self.updater = updater
        sections = []
        super.init()
        reload()
    }
    
    public func reload() {
        updater.updateWithViewModel(self)
    }
}

public class SectionViewModel: ViewModel {
    
    public let cells: [CellViewModel]
    
    public required init(cells: [CellViewModel]) {
        self.cells = cells
    }
}

public class CellViewModel: ViewModel {
    
    lazy var cellIdentifier: String = {
        return NSStringFromClass(self.viewClass())
    }()
}

public class CollectionCellViewModel: CellViewModel {
    
    public func cellSize() -> CGSize {
        return CGSizeMake(44, 44)
    }
}

public class TableCellViewModel: CellViewModel {
    
    public func cellHeight() -> CGFloat {
        return 44
    }
}
