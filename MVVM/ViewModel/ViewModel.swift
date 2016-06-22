//
//  ViewModel.swift
//  GIFMash
//
//  Created by Marko Hlebar on 08/06/2016.
//  Copyright © 2016 Marko Hlebar. All rights reserved.
//

import Foundation

public protocol ViewModelProtocol {
    
    func uniqueIdentifier() -> String
    func viewClass() -> AnyClass
}