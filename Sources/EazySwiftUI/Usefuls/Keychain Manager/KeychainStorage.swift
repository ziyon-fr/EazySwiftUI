//
//  KeychainStorage.swift
//  
//
//  Created by Elioene Silves Fernandes on 09/05/2024.
//

import SwiftUI

/// A property wrapper for storing and retrieving data in the Keychain.
@propertyWrapper
public struct KeyChainStorage: DynamicProperty {
    
    @State var data: Data?
    var key: String
    var account: String
    
    /// The wrapped value representing the data stored in the Keychain.
    public var wrappedValue: Data? {
        /// Getter: Retrieves data from the Keychain.
        get { KeychainManager.shared.read(key: key, account: account) }
        /// Setter: Updates data in the Keychain.
        nonmutating set {
            let newData = setdata(newValue)
            KeychainManager.shared.save(data: newData, for: key, account: account)
            data = newValue
        }
    }
    
    /// Initializes the KeyChainStorage property wrapper.
    ///
    /// - Parameters:
    ///   - key: The key associated with the data.
    ///   - account: The account associated with the data.
    public init(_ key: String, account: String) {
        self.key = key
        self.account = account
        /// Setting initial state for keychain
        _data = State(wrappedValue: KeychainManager.shared.read(key: key, account: account))
    }
    
    /// Sets the data for the KeyChainStorage.
    ///
    /// - Parameter newValue: The new value to be set.
    /// - Returns: The updated data.
    private func setdata(_ newValue: Data?) -> Data {
        guard let newValue else {
            data = nil
            KeychainManager.shared.delete(key: key, account: account)
            return .init()
        }
        return newValue
    }
}

//MARK: - Example
struct KeychainStorageExample: View {
    @KeyChainStorage("SafeStorageKey", account: "SafeStorageAccount") private var safeStorage
    var body: some View {
        
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                    
                if let safeStorage {
                    Text(String(data: safeStorage, encoding: .utf8) ?? .init())
                        .font(.headline.bold())
                } else {
                    Button("Press me to encode safeData") {
                        
                        safeStorage = "Mypassword".data(using: .utf8)
                    }
                }
            }.navigationTitle("Keychain Manager")
        }
    }
}

#Preview {
    KeychainStorageExample()
}
