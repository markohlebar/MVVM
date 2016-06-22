//
//  ViewUpdateHandler.swift
//  GIFMash
//
//  Created by Marko Hlebar on 15/06/2016.
//  Copyright © 2016 Marko Hlebar. All rights reserved.
//

import Foundation

public protocol ViewUpdateHandler {
    
    func updateWithViewModel(viewModel: ViewModelProtocol)
}