//
//  Created by Ricardo Santos on 19/08/2020.
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import SwiftUI
import Combine
import Foundation

//
// MARK: - Utils
//

public extension AnyPublisher {
    static func just(_ o: Output) -> Self {
        Just<Output>(o).setFailureType(to: Failure.self).eraseToAnyPublisher()
    }

    static func error(_ f: Failure) -> Self {
        Fail<Output, Failure>(error: f).eraseToAnyPublisher()
    }

    static func empty() -> Self {
        Empty<Output, Failure>().eraseToAnyPublisher()
    }

    static func never() -> Self {
        Empty<Output, Failure>(completeImmediately: false).eraseToAnyPublisher()
    }
    
    func delay(seconds: TimeInterval) -> AnyPublisher<Output, Failure> {
        delay(milliseconds: seconds * 1000)
    }

    func delay(milliseconds: TimeInterval) -> AnyPublisher<Output, Failure> {
        let timer = Just<Void>(())
            .delay(for: .milliseconds(Int(milliseconds)), scheduler: RunLoop.main)
            .setFailureType(to: Failure.self)
        return zip(timer)
            .map { $0.0 }
            .eraseToAnyPublisher()
    }
}

//
// MARK: - Error
//

public extension Publisher {
    var genericError: AnyPublisher<Self.Output, Error> {
        mapError({ (error: Self.Failure) -> Error in return error }).eraseToAnyPublisher()
    }

    var underlyingError: Publishers.MapError<Self, Failure> {
        mapError {
            ($0.underlyingError as? Failure) ?? $0
        }
    }

    func ignoreErrorJustComplete(_ onError: ((Error) -> Void)? = nil) -> AnyPublisher<Output, Never> {
        self
            .catch({ error -> AnyPublisher<Output, Never> in
                onError?(error)
                return .empty()
            })
            .eraseToAnyPublisher()
    }
}

//
// MARK: - Debug
//

public extension Publisher {

    func debugPublisher(file: String = #file,
                        function: String = #function,
                        id: String,
                        to stream: TextOutputStream? = nil) -> Publishers.Print<Self> {
        let filePrety = file.components(separatedBy: "/").last!
        let location = "# Publisher Debug : \(Date()) | [\(function)] @ [\(filePrety)]\n  \(id)"
        // swiftlint:disable logs_rule_1
        return print(location, to: stream)
        // swiftlint:enable logs_rule_1
    }
    
    func sampleOperator<T>(source: T) -> AnyPublisher<Self.Output, Self.Failure> where T: Publisher, T.Output: Equatable, T.Failure == Self.Failure {
        combineLatest(source)
            .removeDuplicates(by: { (first, second) -> Bool in first.1 == second.1 })
            .map { first in first.0 }
        .eraseToAnyPublisher()
    }

    func sinkToReceiveValue(_ result: @escaping (Result<Output, Failure>) -> Void) -> AnyCancellable {
        sink(receiveCompletion: { completion in
            switch completion {
            case let .failure(error): result(.failure(error))
            case .finished: _ = ()
            }
        }, receiveValue: { value in
            result(.success(value))
        })
    }

}

//
// MARK: - Driver
//

public typealias Driver<T> = AnyPublisher<T, Never>

extension Publisher {
    public func asDriver() -> Driver<Output> {
        return self.catch { _ in Empty() }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    public static func just(_ output: Output) -> Driver<Output> {
        return Just(output).eraseToAnyPublisher()
    }
    
    public static func empty() -> Driver<Output> {
        return Empty().eraseToAnyPublisher()
    }
}

//
// MARK: - ActivityTracker
//

public typealias ActivityTracker = CurrentValueSubject<Bool, Never>
public typealias FieldActivityTracker = CurrentValueSubject<(String, Bool), Never>

public extension Publisher /*where Failure: Error */{
    func trackActivity(_ activityTracker: ActivityTracker) -> AnyPublisher<Output, Failure> {
        return handleEvents(receiveSubscription: { _ in
            activityTracker.send(true)
        }, receiveCompletion: { _ in
            activityTracker.send(false)
        }, receiveCancel: {
            activityTracker.send(false)
        })
        .eraseToAnyPublisher()
    }
    
    func trackFieldActivity(_ activityTracker: FieldActivityTracker, key: String) -> AnyPublisher<Output, Failure> {
        return handleEvents(receiveSubscription: { _ in
            activityTracker.send((key, true))
        }, receiveCompletion: { _ in
            activityTracker.send((key, false))
        }, receiveCancel: {
            activityTracker.send((key, false))
        })
        .eraseToAnyPublisher()
    }
}

//
// MARK: - ErrorTracker
//

public typealias ErrorTracker = PassthroughSubject<Error, Never>

public extension Publisher /*where Failure: Error */{
    func trackError(_ errorTracker: ErrorTracker) -> AnyPublisher<Output, Failure> {
        return handleEvents(receiveCompletion: { completion in
            if case let .failure(error) = completion {
                errorTracker.send(error)
            }
        })
        .eraseToAnyPublisher()
    }
}
