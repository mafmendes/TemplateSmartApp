//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation

// swiftlint:disable logs_rule_1

//
// https://blog.nfnlabs.in/run-tasks-on-background-thread-swift-5d3aec272140
//

public extension CommonExtension where Target == DispatchQueue {

}

public extension DispatchQueue {

    static let defaultDelay: Double = Common_Constants.defaultAnimationsTime

    enum Tread { case main, background }

    private static var _onceTracker = [String]()
    static func onceTrackerClean() {
        Common_Logs.warning("DispatchQueue._onceTracker cleaned")
        _onceTracker = []
    }

    func synced(_ lock: Any, closure: () -> Void) {
        objc_sync_enter(lock)
        closure()
        objc_sync_exit(lock)
    }
    
    @discardableResult static func executeOnce(token: String, block:() -> Void) -> Bool {
        objc_sync_enter(self); defer { objc_sync_exit(self) }
        guard !_onceTracker.contains(token) else { return false }
        _onceTracker.append(token)
        block()
        return true
    }

    static func executeWithDelay(tread: Tread=Tread.main, delay: Double=defaultDelay, block:@escaping () -> Void) {
        if tread == .main {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) { block() }
        } else { DispatchQueue.global(qos: DispatchQoS.QoSClass.background).asyncAfter(deadline: .now() + delay) { block() } }
    }

    static func executeIn(tread: Tread, block: @escaping () -> Void) {
        if tread == .main {
            executeInMainTread(block)
        } else { executeInBackgroundTread(block) }
    }

    static func executeInMainTread(_ block:@escaping () -> Void) {
        DispatchQueue.main.async(execute: { block() })
    }

    static func executeInBackgroundTread(_ block:@escaping () -> Void) {
        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async(execute: { block(); })
    }
    
}
