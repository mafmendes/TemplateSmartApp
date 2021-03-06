//
//  Created by Ricardo Santos on 28/02/2021.
//

import Foundation
import Combine

// swiftlint:disable logs_rule_1

//
// https://betterprogramming.pub/how-to-create-your-own-combine-subscriber-in-swift-5-702b3f9c68c4
// How to Create Your Own Combine Subscriber in Swift 5
//

// We have to implement three required methods:
// 1 - One that specifies the number of values our subscriber can receive
// 2 - One that handles the received input and expands the number of values the subscriber can receive
// 3 - One that handles the completion event

extension CommonNameSpace {
    class GenericSubscriber<T>: Subscriber {
        typealias Input = T       // Mandatory for Subscriber protocol
        typealias Failure = Never // Mandatory for Subscriber protocol

        // We have no limitation for the count of Strings we’d receive, so we specify an .unlimited enum case.
        func receive(subscription: Subscription) {
            subscription.request(.unlimited)
        }

        // Because we’ve already specified the .unlimited number of values, we return .none so the max limit remains the same.
        func receive(_ input: T) -> Subscribers.Demand {
            Common_Logs.info("Received: \(input), \( T.self)")
            return .none
        }

        func receive(completion: Subscribers.Completion<Never>) {
            Common_Logs.info("Completion event: \(completion)")
        }
    }
}

extension CommonNameSpace {
    class CustomSubscriber: Subscriber {
        typealias Input = String  // Mandatory for Subscriber protocol
        typealias Failure = Never // Mandatory for Subscriber protocol

        // First, let’s specify the the maximum number of future values:
        // We have no limitation for the count of Strings we’d receive, so we specify an .unlimited enum case.
        func receive(subscription: Subscription) {
            subscription.request(.unlimited)
        }

        // Because we’ve already specified the .unlimited number of values, we return .none so the max limit remains the same.
        func receive(_ input: String) -> Subscribers.Demand {
            Common_Logs.info("Received: \(input) Transformed into: \(input.uppercased())")
            return .none
        }

        func receive(completion: Subscribers.Completion<Never>) {
            Common_Logs.info("Completion event: \(completion)")
        }
    }
}

fileprivate extension CommonNameSpace {
    func sample1() {
        let customPublisher = ["Warsaw", "Barcelona", "New York", "Toronto"].publisher
        let customSubscriber = CustomSubscriber()
        customPublisher.subscribe(customSubscriber)
    }

    func sample2() {
        let publisherOfInts = [1, 2, 3, 4].publisher

        let publisherOfStrings = ["1", "2", "3", "4"].publisher

        let subscriberOfInt = GenericSubscriber<Int>()
        let subscriberOfString = GenericSubscriber<String>()

        publisherOfInts.subscribe(subscriberOfInt)
        publisherOfStrings.subscribe(subscriberOfString)
    }
}
