//
//  File 2.swift
//  
//
//  Created by Ricardo Santos on 22/02/2021.
//

import Foundation

public extension CommonNameSpace {
    enum Result<T> {
        case success(T)
        case failure(Error)
    }
}
