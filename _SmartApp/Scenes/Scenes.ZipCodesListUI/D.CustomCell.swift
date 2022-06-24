//
//  D.CustomCell.swift
//  SmartApp
//
//  Created by Mendes, Mafalda Joana on 18/04/2022.
//

import Foundation
import UIKit
import Combine
import SwiftUI
//
import Common
import BaseUI
import BaseDomain
import DevTools
import Resources
import Designables
import AppConstants
import AppDomain

public extension VM {
    enum CustomCell {

        //
        // Sizes
        //
        
        enum Sizes {
            static var imageDogWidth: CGFloat {SizeNames.size_9.cgFloat}
            static var imageDogHeight: CGFloat {SizeNames.size_8.cgFloat}
            static var imageModeWidth: CGFloat {SizeNames.size_9.cgFloat}
            static var imageModeHeight: CGFloat {SizeNames.size_8.cgFloat}
        }
        
        //
        // Constants
        //
                
        enum Constants {
           
        }
        
        enum URLS {
            static var urlImageDog: String { "https://www.caonosso.pt/wp-content/uploads/2020/12/beagle-3.jpg"}
            static var urlImageDarkMode: String { "https://addons.mozilla.org/user-media/previews/full/239/239747.png?modified=1622132681"}
            static var urlImagLightMode: String { "https://i.pinimg.com/originals/03/1a/9f/031a9faf34d07a5d8259100b0409c8fe.jpg"}
        }
        
        //
        // ViewOutput
        //
        
        // struct naming convention: ViewOutput, allways, Hashable allways
        public enum ViewOutput {
            
        }
        
        // Objects marked as @ObservedObject need to implement ObservableObject protocol and have
        // properties defined with the @Published property wrapper, indicating which properties
        // trigger observation notifications when changed.
        public class ViewInput {
           
        }
    }
}
