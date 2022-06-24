//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
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

extension V.ToolBar {
    
    // Sugar
    func installOn(view: UIView) {
        view.addSubview(self)
        self.layouts.centerXToSuperview()
        
        self.layouts.size(VM.ToolBar.Sizes.defaultSize)
        self.layouts.bottomToSuperview(offset: -VM.ToolBar.Sizes.distanceFromBottom, usingSafeArea: false)
    }
}

extension V {
    
    class ToolBar: BaseGenericView {
        
        deinit {
            NotificationCenter.default.removeObserver(self)
            DevTools.Log.trace("\(Self.self) deinit", .generic)
        }
        
        public var output = GenericObservableObjectForHashable<VM.ToolBar.ViewOutput.Action>()
        private func publish(selectedIndex: Int, identifier: String?, state: SmartState) {
            let identifier = AccessibilityIdentifier(rawValue: identifier ?? "") ?? .na
            let vm: VM.ToolBar.ViewOutput.Action = .taped(index: selectedIndex,
                                                              id: identifier,
                                                              state: state)
            DevTools.Log.trace(vm, .view)
            output.value.send(vm)
        }
        
        private var selectedBtn: UIButton?
                
        private lazy var containerView: UIView = {
            UIFactory.containerView()
        }()
        
        private lazy var separatorBar: UIView = {
            UIFactory.containerView()
        }()
        
        lazy var btnTab1: UIButton = {
            UIFactory.btnToolbar(image: ImageName.car.uiImage, accessibilityIdentifier: .toolBarBtn1WithMeaningfulName)
        }()
        
        lazy var btnTab2: UIButton = {
            UIFactory.btnToolbar(image: ImageName.charging.uiImage, accessibilityIdentifier: .toolBarBtn2WithMeaningfulName)
        }()
        
        lazy var btnTab3: UIButton = {
            UIFactory.btnToolbar(image: ImageName.charging.uiImage, accessibilityIdentifier: .toolBarBtn3WithMeaningfulName)
        }()
        
        lazy var btnTab4: UIButton = {
            UIFactory.btnToolbar(image: ImageName.charging.uiImage, accessibilityIdentifier: .toolBarBtn4WithMeaningfulName)
        }()
        
        private var btnOverlayCenterConstraints: [NSLayoutConstraint] = [] {
            willSet {
                NSLayoutConstraint.deactivate(btnOverlayCenterConstraints)
            }
            didSet {
                NSLayoutConstraint.activate(btnOverlayCenterConstraints)
            }
        }
        
        public override func prepareLayoutCreateHierarchy() {
            addSubview(containerView)
            containerView.addSubview(btnTab1)
            containerView.addSubview(btnTab2)
            containerView.addSubview(btnTab3)
            containerView.addSubview(btnTab4)
            containerView.addSubview(separatorBar)
        }
        
        public override func prepareLayoutBySettingAutoLayoutsRules() {
            containerView.layouts.edgesToSuperview()
            
            separatorBar.layouts.topToSuperview()
            separatorBar.layouts.leadingToSuperview()
            separatorBar.layouts.trailingToSuperview()
            separatorBar.layouts.height(1)

            let items = [btnTab1, btnTab2, btnTab3, btnTab4]
            items.forEach { (some) in
                some.layouts.topToSuperview(offset: SizeNames.size_2.cgFloat)
                some.layouts.size(VM.ToolBar.Sizes.defaultSizeButton)
            }
                    
            /*
             margin = screenWidth / 8
                 margin     margin      margin      margin      margin     margin       margin      margin
            |-----------|-----------|-----------|-----------|-----------|-----------|-----------|-----------|
                        |                       |     ScreenCenter      |                       |
                       Btn1                   Btn2                    Btn3                     Btn4
             */
            let margin = (screenWidth / CGFloat(items.count * 2))
            btnTab1.layouts.centerXToSuperview(offset: -margin * 3)
            btnTab2.layouts.centerXToSuperview(offset: -margin)
            btnTab3.layouts.centerXToSuperview(offset: margin)
            btnTab4.layouts.centerXToSuperview(offset: margin * 3)
        }
                
        public override func prepareLayoutByFinishingPrepareLayout() {
            let size = CGSize(width: SizeNames.size_8.cgFloat, height: SizeNames.size_8.cgFloat)
            if VM.ToolBar.Constants.cornerRadius > 0 {
                containerView.common.addCorner(radius: VM.ToolBar.Constants.cornerRadius)
            }
            [btnTab2, btnTab3, btnTab4].forEach { (some) in
                some.layouts.size(size)
            }
            btnTab1.layouts.size(size)
        }
        
        open override func setupColorsAndStyles() {
            backgroundColor = .clear
            containerView.backgroundColor = ColorSemantic.backgroundSecondary.uiColor
            separatorBar.backgroundColor  = ColorSemantic.backgroundSecondary.uiColor.alpha(0.6)
        }
        
        private func buttonFor(tab: C.TabBarCoordinator.Action) -> UIButton {
            switch tab {
            case .dismiss: return btnTab1
            case .tab1WithMeaningfulName: return btnTab1
            case .tab2WithMeaningfulName: return btnTab2
            case .tab3WithMeaningfulName: return btnTab3
            case .tab4WithMeaningfulName: return btnTab4
            }
        }
        
        /// Highlight a tab, JUST Highlight, dont change it...
        public var highlightedTab: C.TabBarCoordinator.Action = .tab1WithMeaningfulName {
            didSet {
                C.TabBarCoordinator.Action.allCases.filter({ $0 != highlightedTab }).forEach { tab in
                    buttonFor(tab: tab).backgroundColor = ColorSemantic.allCool.uiColor
                }
                buttonFor(tab: highlightedTab).backgroundColor = ColorSemantic.primary.uiColor
            }
        }
        
        public override func setupViewUIRx() {
   
            [(btnTab1, 1), (btnTab2, 2), (btnTab3, 3), (btnTab4, 4)].forEach { (btn, index) in
                btn.combine.touchUpInsidePublisher.sink { [weak self] (some) in
                    guard let self = self else { return }
                    /*self.selectedBtn = (some as? App_Designables_UIKit.ButtonIcon)
                    [self.btnTab1, self.btnTab2, self.btnTab3, self.btnTab4].filter { $0.smartState == .selected }.forEach { (some) in
                        some.smartState = .default
                    }
                    self.selectedBtn?.smartState = .selected*/
    
                    self.publish(selectedIndex: index, identifier: some.accessibilityIdentifier, state: .selected)
                }.store(in: cancelBag, subscriptionId: btn.constrainableId)
            }
        }
    }
}
