//
//  Result+Extensions.swift
//  Extensions
//
//  Created by Ricardo Santos on 19/08/2020.
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import Foundation
import Combine

public extension Swift.Result {
    var isSuccess: Bool {
        switch self {
        case .success: return true
        case .failure: return false
        }
    }

    var sucessUnWrappedValue: Any? {
        switch self {
        case .success(let unWrappedValue): return unWrappedValue
        case .failure: return nil
        }
    }
    
    var failureUnWrappedValue: Error? {
        switch self {
        case .success: return nil
        case .failure(let error): return error
        }
    }
    
    var failureUnWrappedStringValue: String {
        if let failureUnWrappedValue = failureUnWrappedValue {
            return "\(failureUnWrappedValue)"
        } else {
            return ""
        }
    }
    
}
