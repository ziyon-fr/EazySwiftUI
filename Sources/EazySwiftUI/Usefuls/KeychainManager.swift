//
//  KeychainManager.swift
//  
//
//  Created by Elioene Silves Fernandes on 09/05/2024.
//

import SwiftUI

/// KeyChainManager class for managing data in the Keychain.
final class KeychainManager {
    
    /// Singleton instance of the KeyChainManager.
    static let shared = KeychainManager()
    
    /// Generates a query dictionary for Keychain operations.
    ///
    /// - Parameters:
    ///   - data: The data to be stored.
    ///   - key: The key associated with the data.
    ///   - account: The account associated with the data.
    /// - Returns: CFDictionary representing the query.
    private func generateDataQuery(
        data: Data,
        for key: String,
        account: String
    ) -> CFDictionary {
        let query = [
            kSecValueData: data,
            kSecAttrAccount: account,
            kSecAttrService: key,
            kSecClass: kSecClassGenericPassword
        ] as CFDictionary
        return query
    }
    
    /// Updates data in the Keychain.
    ///
    /// - Parameters:
    ///   - data: The data to be updated.
    ///   - key: The key associated with the data.
    ///   - account: The account associated with the data.
    private func updateData(data: Data, for key: String, account: String) {
        let updatedQuery = generateDataQuery(data: data, for: key, account: account)
        let updateAttributes = [kSecValueData : data] as CFDictionary
        SecItemUpdate(updatedQuery, updateAttributes)
    }
    
    /// Saves data in the Keychain.
    ///
    /// - Parameters:
    ///   - data: The data to be saved.
    ///   - key: The key associated with the data.
    ///   - account: The account associated with the data.
    func save(data: Data, for key: String, account: String) {
        let query = generateDataQuery(data: data, for: key, account: account)
        let status = SecItemAdd(query, nil)
        switch status {
        case errSecSuccess:
            print("Success Saving Data")
        case errSecDuplicateItem:
            updateData(data: data, for: key, account: account)
        default:
            print("From: \(Self.self) - Error", status.description)
        }
    }
    
    /// Reads data from the Keychain.
    ///
    /// - Parameters:
    ///   - key: The key associated with the data.
    ///   - account: The account associated with the data.
    /// - Returns: The data associated with the key and account.
    func read(key: String, account: String) -> Data? {
        let query = [
            kSecAttrAccount: account,
            kSecAttrService: key,
            kSecClass: kSecClassGenericPassword,
            kSecReturnData: true
        ] as CFDictionary
        var resultData: AnyObject?
        SecItemCopyMatching(query, &resultData)
        return resultData as? Data
    }
    
    /// Deletes data from the Keychain.
    ///
    /// - Parameters:
    ///   - key: The key associated with the data to be deleted.
    ///   - account: The account associated with the data to be deleted.
    func delete(key: String, account: String) {
        let query = [
            kSecAttrAccount: account,
            kSecAttrService: key,
            kSecClass: kSecClassGenericPassword,
        ] as CFDictionary
        SecItemDelete(query)
    }
}

