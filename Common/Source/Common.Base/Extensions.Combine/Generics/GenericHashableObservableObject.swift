//
//  Created by Ricardo Santos on 27/02/2021.
//

import Foundation
import Combine
import SwiftUI
import UIKit

// swiftlint:disable logs_rule_1

extension CommonNameSpace {

    /**
     `ObservableObject` is a protocol you adopt on your reference type and `@ObservedObject` is a property wrapper for a view property, which holds a reference.
     By using `@ObservedObject` on a property, you are basically saying to SwiftUI to go and look inside the object that the property holds a reference to.
     `PassthroughSubject` As in [Apple Docs](https://developer.apple.com/documentation/combine/passthroughsubject) : _A subject that broadcasts elements to downstream subscribers._
    */

    //
    // MARK: - Use Case 1
    //
    // Use Case 1, for `GenericObservableObjectForHashableState<T: Hashable>`
    // Model is state of `GenericObservableObjectForHashableState<T: Hashable>` and  you just need to know the final value
    //
    public class GenericObservableObjectForHashableState<T: Hashable>: ObservableObject {
        public init() { }
        public var state = PassthroughSubject<CommonNameSpace.HashableModelState<T>, Never>()
    }

    //
    // MARK: - Use Case 2
    //
    // Use Case 2, for `GenericObservableObjectForHashableStateWithObservers<T: Hashable>`
    // Model is state of `GenericObservableObjectForHashableStateWithObservers<T: Hashable>` and  need to know `willChange` and `didChange`
    //
    public class GenericObservableObjectForHashableStateWithObservers<T: Hashable>: ObservableObject {
        public init() { }
        public var willChange = PassthroughSubject<GenericObservableObjectForHashableStateWithObservers<T>, Never>()
        public var didChange = PassthroughSubject<GenericObservableObjectForHashableStateWithObservers<T>, Never>()
        public var state: CommonNameSpace.HashableModelState<T>? {
            willSet {
                willChange.send(self)
            }
            didSet {
                didChange.send(self)
            }
        }
    }

    //
    // MARK: Use Case 3
    //
    // Use Case 3, for `<T: Hashable>`
    // Model is value of `GenericObservableObjectForHashable<T: Hashable>` and  you just need to know the final value
    //
    public class GenericObservableObjectForHashable<T: Hashable>: ObservableObject {
        public init() { }
        public var value = PassthroughSubject<T, Never>()
    }

    //
    // MARK: Use Case 4
    //
    // Use Case 4, for `<T: Hashable>`
    // Model is a value of ` Hashable` and  need to know `willChange` and `didChange`
    public class GenericObservableObjectForHashableWithObservers<T: Hashable>: ObservableObject {
        public init() { }
        public var willChange = PassthroughSubject<GenericObservableObjectForHashableWithObservers<T>, Never>()
        public var didChange = PassthroughSubject<GenericObservableObjectForHashableWithObservers<T>, Never>()
        public var value: T? {
            willSet {
                willChange.send(self)
            }
            didSet {
                didChange.send(self)
            }
        }
    }
}

extension CommonNameSpace {
    // Just a "bad" example
    fileprivate class NonGenericSampleObservableStateContainerV1: ObservableObject {
        var state = PassthroughSubject<CommonNameSpace.HashableModelState<CommonNameSpace.VM_SampleTableItem>, Never>()
    }

    // Just a "bad" example
    fileprivate class NonGenericSampleObservableStateContainerV2: ObservableObject {
        var willChange = PassthroughSubject<NonGenericSampleObservableStateContainerV2, Never>()
        var didChange = PassthroughSubject<NonGenericSampleObservableStateContainerV2, Never>()
        var state: CommonNameSpace.HashableModelState<CommonNameSpace.VM_SampleTableItem>? {
            willSet {
                willChange.send(self)
            }
            didSet {
                didChange.send(self)
            }
        }
    }
}

extension CommonNameSpace {

    struct VM_SampleTableItem: Hashable {

        let enabled: Bool
        let title: String
        let subtitle: String

        func hash(into hasher: inout Hasher) {
            hasher.combine(enabled)
            hasher.combine(title)
            hasher.combine(subtitle)

        }
        init(enabled: Bool = true, title: String, subtitle: String = "") {
            self.enabled = enabled
            self.title = title
            self.subtitle = subtitle
        }
    }
}

fileprivate extension CommonNameSpace {

    class SampleView: UIView {
        public let cancelBag = CancelBag()
        var viewStateBinderA = NonGenericSampleObservableStateContainerV1()
        var viewStateBinderB = NonGenericSampleObservableStateContainerV2()
        var viewStateBinderC = GenericObservableObjectForHashableState<CommonNameSpace.VM_SampleTableItem>()
        var viewStateBinderD = GenericObservableObjectForHashableStateWithObservers<CommonNameSpace.VM_SampleTableItem>()

        public func setupViewUIRx() {

            viewStateBinderA.state.sink { [weak self] (state) in
                guard let self = self else { return }
                self.handle(state: state)
            }.store(in: cancelBag)

            viewStateBinderB.didChange.sink { [weak self] (some) in
                guard let self = self, let state = some.state else { return }
                self.handle(state: state)
            }.store(in: cancelBag)

            viewStateBinderC.state.sink { [weak self] (state) in
                guard let self = self else { return }
                self.handle(state: state)
            }.store(in: cancelBag)

            viewStateBinderD.didChange.sink { [weak self] (some) in
                guard let self = self, let state = some.state else { return }
                self.handle(state: state)
            }.store(in: cancelBag)
        }

        func handle(state: CommonNameSpace.HashableModelState<CommonNameSpace.VM_SampleTableItem>) {

            Common_Utils.executeInMainTread {
                switch state {
                case .notLoaded:
                    Common_Logs.info("notLoaded")
                case .loading: _ = ()
                    Common_Logs.info("loading")
                case .loaded(let model):
                    Common_Logs.info("loaded \(model)")
                case .error(let error):
                    Common_Logs.error("error \(error)")
                }
            }
        }
    }

    struct VM_SampleViewModel {
        
        @ObservedObject var viewStateBinderA: NonGenericSampleObservableStateContainerV1
        @ObservedObject var viewStateBinderB: NonGenericSampleObservableStateContainerV2

        @ObservedObject var viewStateBinderC: GenericObservableObjectForHashableState<VM_SampleTableItem>
        @ObservedObject var viewStateBinderD: GenericObservableObjectForHashableStateWithObservers<VM_SampleTableItem>

        init(viewStateBinderA: NonGenericSampleObservableStateContainerV1,
             viewStateBinderB: NonGenericSampleObservableStateContainerV2,
             viewStateBinderC: GenericObservableObjectForHashableState<VM_SampleTableItem>,
             viewStateBinderD: GenericObservableObjectForHashableStateWithObservers<VM_SampleTableItem>) {
            self.viewStateBinderA = viewStateBinderA
            self.viewStateBinderB = viewStateBinderB
            self.viewStateBinderC = viewStateBinderC
            self.viewStateBinderD = viewStateBinderD
        }

        func fetch() {
            viewStateBinderA.state.send(.loading)
            viewStateBinderC.state.send(.loading)
            viewStateBinderB.state = .loading
            viewStateBinderD.state = .loading
        }
    }

    class SampleViewController: UIViewController {
        var viewModel: VM_SampleViewModel!
        let genericView = SampleView()
        override func loadView() {
            super.loadView()
            viewModel = VM_SampleViewModel(viewStateBinderA: genericView.viewStateBinderA,
                                           viewStateBinderB: genericView.viewStateBinderB,
                                           viewStateBinderC: genericView.viewStateBinderC,
                                           viewStateBinderD: genericView.viewStateBinderD)
            viewModel.fetch()
        }
    }
}
