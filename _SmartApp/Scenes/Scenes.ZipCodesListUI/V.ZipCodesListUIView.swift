//
//  V.ZipCodesListUIView.swift
//  SmartApp
//
//  Created by Santos, Ricardo Patricio dos  on 06/04/2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import Foundation
import SwiftUI
import Combine
//
import Common
import DevTools
import BaseDomain
import AppDomain
import BaseUI
import Designables
import Resources
import AppConstants

//
// V.ZipCodesListUIView files are used for:
//  - Build the UI
//  - Expose to the UIViewController (via Combine and on extension on file end) the user interactor events
//
// Naming convention: Given a Scene named ZipCodesListUI -> ZipCodesListUIView
//

#if canImport(SwiftUI) && DEBUG
// Cant be private/fileprivate
// struct name cant start with _
struct PZipCodesListUIVPreviews: PreviewProvider {
    static var previews: some View {
        PZipCodesListUIVCPreviews.previews
    }
}
#endif

extension V {

    public class ZipCodesListUIView: BaseGenericView,
                                               ZipCodesListUIViewProtocol,
                                               GenericViewProtocol,
                                     MVVMGenericViewProtocol, UITableViewDelegate, UITableViewDataSource {
        
        deinit {
            NotificationCenter.default.removeObserver(self)
            DevTools.Log.trace("\(Self.self) deinit", .generic)
        }

        public typealias ViewData = VM.ZipCodesListUI.ViewInput.ViewData
        public typealias ViewOutput = VM.ZipCodesListUI.ViewOutput.Action
        public var output = GenericObservableObjectForHashable<ViewOutput>()
        public var input = MVVMViewInputObservable<ViewData>()
        
        private var tableViewDataSource: [VM.ZipCodesListUIHolder.TableItem] = [] {
            didSet {
                
                tableView.reloadData()
            }
        }
                
        //
        // MARK: - UI Elements (Private and lazy by default)
        //
        private var backgroundGradient: CAGradientLayer?
        
        private lazy var searchField: UISearchTextField = {
            UISearchTextField()
        }()
        
//        private lazy var ZipCodesListUIHolder: (container: UIView, compoment: V.ZipCodesListUIHolder) = {
//            let compoment = V.ZipCodesListUIHolder(input: .init(title: "", items: []))
//            return (compoment.uiView, compoment)
//        }()
        private lazy var tableView: UITableView = {
            UITableView()

        }()
        //
        // MARK: - View Life Cicle : Mandatory
        //
        
        // This function is called automatically by super BaseGenericView
        // There are 3 functions specialised according to what we are doing. Please use them accordingly
        // Function 1/3 : JUST to add stuff to the view....
        public override func prepareLayoutCreateHierarchy() {
            addSubview(searchField)
            //addSubview(ZipCodesListUIHolder.container)
            addSubview(tableView)
        }
        
        // This function is called automatically by super BaseGenericView
        // There are 3 functions specialised according to what we are doing. Please use them accordingly
        // Function 2/3 : JUST to setup layout rules zone....
        public override func prepareLayoutBySettingAutoLayoutsRules() {
            searchField.layouts.topToSuperview(offset: 0, usingSafeArea: true)
            searchField.layouts.leadingToSuperview(offset: SizeNames.defaultMargin)
            searchField.layouts.trailingToSuperview(offset: SizeNames.defaultMargin)
            searchField.layouts.height(SizeNames.defaultMargin * 2)
            
//            ZipCodesListUIHolder.container.layouts.topToBottom(of: searchField, offset: SizeNames.defaultMargin)
//            ZipCodesListUIHolder.container.layouts.leadingToSuperview(offset: 0)
//            ZipCodesListUIHolder.container.layouts.trailingToSuperview(offset: 0)
//            ZipCodesListUIHolder.container.layouts.bottomToSuperview()
            
            tableView.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: SizeNames.defaultMargin).isActive = true
            tableView.leftAnchor.constraint(equalTo: superview!.leftAnchor).isActive = true
            tableView.bottomAnchor.constraint(equalTo: superview!.bottomAnchor).isActive = true
            tableView.rightAnchor.constraint(equalTo: superview!.rightAnchor).isActive = true
        }
        
        // This function is called automatically by super BaseGenericView
        // There are 3 functions specialised according to what we are doing. Please use them accordingly
        // Function 3/3 : Stuff that is not included in [prepareLayoutCreateHierarchy] and [prepareLayoutBySettingAutoLayoutsRules]
        public override func prepareLayoutByFinishingPrepareLayout() {
            //ZipCodesListUIHolder.container.alpha = 0.8
            tableView.register(V.CustomCell.self, forCellReuseIdentifier: VM.ZipCodesListUI.Constants.tableIdentifier)
            tableView.dataSource = self
            tableView.delegate = self
            tableView.translatesAutoresizingMaskIntoConstraints = false
        }
        
        public override func setupColorsAndStyles() {
            backgroundGradient = installGradientBackground(backgroundGradient: backgroundGradient)
            backgroundColor = ColorSemantic.backgroundPrimary.uiColor
        }
        
        // This function is called automatically by super BaseGenericView
        // All reactive behaviours should be inside this function
        public override func setupViewUIRx() {
            
            // Handle View inputs and to view screen
            input.value.sink { [weak self] (state) in
                guard let self = self else { return }
                self.handle(stateInput: state)
            }.store(in: cancelBag)
            
            searchField.editingChangedPublisher.sinkToReceiveValue { [weak self] (some) in
                guard let self = self else { return }
                if let toSearch = some.sucessUnWrappedValue as? String {
                    self.fwdStateToViewController(.search(value: toSearch))
                }
            }.store(in: cancelBag)
        
        }
    }
}

//
// MARK: - setupWith(viewModel: ViewData)
// This section is mandatory for all (Scene) Views, and is were we andle data sent by the ViewController/ViewModel

extension V.ZipCodesListUIView {

    /// Use to put the screen/view on his initial state, (not necessaring reload all the data)
    func softReLoad() {
        
    }
    
    func handle(stateInput: MVVMViewInput<ViewData>) {
        DevTools.Log.trace(stateInput, .view)
        guard let viewController = asView.common.viewController else { return }
        guard let baseViewController = viewController as? BaseViewController else { return }
        Common_Utils.executeInMainTread { [weak baseViewController] in
            switch stateInput {
            case .loading(model: let model): baseViewController?.displayLoading(viewModel: model)
            case .loaded(let model): self.setupWith(viewModel: model)
            case .error(let error, let devMessage):
                var message = "\(Message.pleaseTryAgainLater.localised)\n\n\(error.localizedDescription)"
                if let error = error as? AppErrors, let messageForUI = error.localisedForUser {
                    message = messageForUI
                }
                baseViewController?.displayError(viewModel: .init(title: "",
                                                                  message: message,
                                                                  devMessage: "\(devMessage)"))
            case .softReLoad: self.softReLoad()
            }
        }
    }

    /// Where to handle the ViewData sent by the ViewModel/ViewController and display it on the view
    func setupWith(viewModel: ViewData) {
        switch viewModel {
        case .display(title: let title, items: let items):
            self.tableViewDataSource = items
            //ZipCodesListUIHolder.compoment.input.title = title
            //ZipCodesListUIHolder.compoment.input.items = items
        case .displayAlert(title: let title, type: let type):
            displayMessage(title: "", title, type: type, actions: [])
            
        }
    }
}

//
// MARK: - Events Simulation (testing)
// All functions used on UnitTests must start with simulate
//

extension V.ZipCodesListUIView {
    
}

//
// MARK: - Private
// All (Scene) Views should have a private section with auxiliar functions
//

private extension V.ZipCodesListUIView {
    func handleMessage(_ message: String) {
        if !message.trim.isEmpty {
            displayMessage(title: "", message, type: .warning, actions: [])
        }
    }
}

//
// MARK: - Events capture (Sugar for View ONLY)
//

private extension V.ZipCodesListUIView {
}

//tableView stubs
extension V.ZipCodesListUIView {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableViewDataSource.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: VM.ZipCodesListUI.Constants.tableIdentifier, for: indexPath) as? V.CustomCell {
            
            cell.cellItem = tableViewDataSource[indexPath.row]
            return cell

        }
        return UITableViewCell()
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let alert = UIAlertController(title: "Alert: \(self.tableViewDataSource[indexPath.row].title)", message: "Are you sure you want to go to a new screen", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {_ in
            self.fwdStateToViewController(.routeToNewScreen(
                city: self.tableViewDataSource[indexPath.row].title,
                imageDark: self.tableViewDataSource[indexPath.row].imageDark.toImage()!,
                imageLight: self.tableViewDataSource[indexPath.row].imageLight.toImage()!,
                postalcode: self.tableViewDataSource[indexPath.row].postalCode))
                }))

        alert.addAction(UIAlertAction(title: "No", style: .default, handler: {_ in

                    // caio aqui ao carregar no Nao

                }))
        self.viewController?.present(alert, animated: true)
    }
                        
}
