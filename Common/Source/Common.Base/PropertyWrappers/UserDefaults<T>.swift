import Foundation
import Combine

/**
 https://github.com/apple/swift-evolution/blob/master/proposals/0258-property-wrappers.md
 https://nshipster.com/propertywrapper/
 https://medium.com/swlh/easy-dependency-injection-with-property-wrappers-in-swift-886a93c28ed4
 https://www.avanderlee.com/swift/property-wrappers/

__If you’re not familiar with Property Wrappers in Swift, it’s not a big deal:__
* We created a struct;
* Added @propertyWrapper before its declaration;
* Every Property Wrapper has to have wrappedValue. In our case, it has a generic type T;
* init gets one parameter: `key` to the variable in UserDefault;

 ```
 class TheViewModel: ObservableObject {
     let objectWillChange = PassthroughSubject<Void, Never>()
     @UserDefaultsPropertyWrapper("ShowOnStart", defaultValue: true)
     var showOnStart: Bool { willSet { objectWillChange.send() } }
 }

 struct VisualDocs_UserDefaultsWithPropertyWrapper: View {
     @ObservedObject var vm = TheViewModel()
     var body: some View {
         VStack {
             Toggle(isOn: $vm.showOnStart) {
                 Text("Show welcome text")
             }
             if vm.showOnStart {
                 Text("Welcome")
             }
         }.padding()
     }
 }
 ```

 ```
 extension UserDefaults {
     @UserDefault(key: "has_seen_app_introduction", defaultValue: false)
     static var hasSeenAppIntroduction: Bool
 }
 ```
*/

public protocol AnyOptional {
    /// Returns `true` if `nil`, otherwise `false`.
    var isNil: Bool { get }
}
extension Optional: AnyOptional {
    public var isNil: Bool { self == nil }
}

public extension CommonNameSpace {
    @propertyWrapper
    struct UserDefaults<T> {
        public let key: String
        public let defaultValue: T
        public init(_ key: String, defaultValue: T) {
            self.key = key
            self.defaultValue = defaultValue
        }
        public var wrappedValue: T {
            get { Foundation.UserDefaults.standard.object(forKey: key) as? T ?? defaultValue }
            set { Foundation.UserDefaults.standard.set(newValue, forKey: key) }
        }
    }
    
    //
    // Projecting a Value From a Property Wrapper
    // https://www.avanderlee.com/swift/property-wrappers/
    //
    
    /**
     
     ```
     let subscription = UserDefaults.$username.sink { username in
         print_("New username: \(username)")
     }
     UserDefaults.username = "Test"
     ```
     */
    
    @propertyWrapper
    struct UserDefaultProjected<Value> {
        public let key: String
        public let defaultValue: Value

        private let publisher = PassthroughSubject<Value, Never>()
        
        public var wrappedValue: Value {
            get {
                return Foundation.UserDefaults.standard.object(forKey: key) as? Value ?? defaultValue
            }
            set {
                // Check whether we're dealing with an optional and remove the object if the new value is nil.
                if let optional = newValue as? AnyOptional, optional.isNil {
                    Foundation.UserDefaults.standard.removeObject(forKey: key)
                } else {
                    Foundation.UserDefaults.standard.set(newValue, forKey: key)
                }
                publisher.send(newValue)
            }
        }

        public var projectedValue: AnyPublisher<Value, Never> {
            return publisher.eraseToAnyPublisher()
        }
    }
}
