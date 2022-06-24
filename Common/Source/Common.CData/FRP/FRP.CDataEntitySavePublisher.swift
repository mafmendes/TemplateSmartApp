import Combine
import CoreData

public struct CDataFRPEntitySavePublisher: Publisher {
    public typealias Output = Bool
    public typealias Failure = NSError

    private let action: FRPCDataStorePublisherAction
    private let context: NSManagedObjectContext

    init(action: @escaping FRPCDataStorePublisherAction, context: NSManagedObjectContext) {
        self.action = action
        self.context = context
    }

    public func receive<S>(subscriber: S) where S: Subscriber, Self.Failure == S.Failure, Self.Output == S.Input {
        let subscription = Subscription(subscriber: subscriber, context: context, action: action)
        subscriber.receive(subscription: subscription)
    }
}

public extension CDataFRPEntitySavePublisher {
    class Subscription<S> where S: Subscriber, Failure == S.Failure, Output == S.Input {
        private var subscriber: S?
        private let action: FRPCDataStorePublisherAction
        private let context: NSManagedObjectContext

        init(subscriber: S, context: NSManagedObjectContext, action: @escaping FRPCDataStorePublisherAction) {
            self.subscriber = subscriber
            self.context = context
            self.action = action
        }
    }
}

extension CDataFRPEntitySavePublisher.Subscription: Subscription {
    public func request(_ demand: Subscribers.Demand) {
        var demand = demand
        guard let subscriber = subscriber, demand > 0 else { return }

        do {
            action()
            demand -= 1
            if context.hasChanges {
                try context.save()
            }
            demand += subscriber.receive(true)
        } catch {
            subscriber.receive(completion: .failure(error as NSError))
        }
    }
}

extension CDataFRPEntitySavePublisher.Subscription: Cancellable {
    public func cancel() {
        subscriber = nil
    }
}
