//
//  Shared.swift
//  UnderstandingPropertyWrappers
//
//  Created by Ratnesh Jain on 29/06/24.
//

import Combine
import Foundation
import SwiftUI

protocol PersistenceStratergy<Value> {
    associatedtype Value
    var key: String { get }
    
    var read: Value? { get }
    func write(_ value: Value)
}

private var sharedStorage: [String: Any] = [:]
struct InMemory<Value>: PersistenceStratergy {
    var key: String
    var read: Value? {
        (sharedStorage[key] as? Value)
    }
    func write(_ value: Value) {
        sharedStorage[key] = value
    }
}

extension PersistenceStratergy {
    static func inMemory<T>(_ key: String) -> Self where Self == InMemory<T> {
        InMemory(key: key)
    }
    
    static func appStorage<T>(_ key: String) -> Self where Self == UserDefault<T> {
        UserDefault(key: key)
    }
}

enum Coder {
    static var jsonEncoder: JSONEncoder = { .init() }()
    static var jsonDecoder: JSONDecoder = { .init() }()
}

struct UserDefault<Value: Codable>: PersistenceStratergy {
    var key: String
    
    let userDefaults = UserDefaults.standard
    
    var read: Value? {
        if let data = userDefaults.value(forKey: key) as? Data {
            return try? Coder.jsonDecoder.decode(Value.self, from: data)
        }
        return nil
    }
    
    func write(_ value: Value) {
        if let data = try? Coder.jsonEncoder.encode(value) {
            userDefaults.setValue(data, forKey: key)
            userDefaults.synchronize()
        }
    }
}

@propertyWrapper
struct Shared<Value> {
    private var storage: Storage
    
    var wrappedValue: Value {
        get {
            self.storage.value
        }
        nonmutating set {
            self.storage.value = newValue
        }
    }
    
    var projectedValue: Binding<Value> {
        Binding {
            self.wrappedValue
        } set: { newValue in
            self.wrappedValue = newValue
        }

    }
    
    init(wrappedValue: Value, _ stratergy: some PersistenceStratergy<Value>) {
        self.storage = .init(value: wrappedValue, stratergy: stratergy)
    }
    
    @Observable
    class Storage {
        let stratergy: any PersistenceStratergy<Value>
        var currentValue: Value
        
        //Patch: using this allows other views (Settings View) to render the correct current value.
        private var flag: Bool = false
        
        var value: Value {
            get {
                // accessing the current value allows to work in the content View, but not being called by Settings view for the updated value.
                _ = currentValue
                if let stored = stratergy.read {
                    return stored
                } else {
                    return currentValue
                }
            }
            set {
                currentValue = newValue
                stratergy.write(newValue)
                // Without this, its working in the first view but does, other view (Settings View) does not re-render correct current value.
                flag.toggle()
            }
        }
        
        init(value: Value, stratergy: some PersistenceStratergy<Value>) {
            self.stratergy = stratergy
            if let storedValue = stratergy.read {
                self.currentValue = storedValue
                self.value = storedValue
            } else {
                self.currentValue = value
                self.stratergy.write(value)
                self.value = value
            }
        }
    }
}
