//
//  ConfigureDefaults.swift
//  SmartApp
//
//  Created by Mendes, Mafalda Joana on 24/06/2022.
//

import Foundation
import UIKit
//
import BaseDomain
import AppDomain
import BaseUI
import AppConstants
final class ConfigureDefaults {
    static var defaults: String {
            get {
                // Read from UserDefaults
                return UserDefaults.standard.string(forKey: VM.Movies.StorageKeys.searchBarStorageKey.rawValue) ?? ""
            }
            set {
                // Save to UserDefaults
                UserDefaults.standard.set(newValue, forKey: VM.Movies.StorageKeys.searchBarStorageKey.rawValue)
            }
        }
}
