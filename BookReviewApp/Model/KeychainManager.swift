//
//  KeychainManager.swift
//  BookReviewApp
//
//  Created by yukifuruhashi on 2024/02/11.
//

import Foundation

//enum KeychainError: Error {
//    case duplicateItem
//    case unknown(status: OSStatus)
//}

// 保存するトークンの種類
enum TokenType: String {
    case accessToken
    case Name
}



// Keychainを扱うクラス
// 継承を防ぐためのfinalをクラスにつけてあげる。
final class KeychainManager {
    
    // 外部からのアクセスはこのsharedというプロパティを介して行うことにするために  static let shared = KeychainManager() と書き、KeychainManagerクラスのインスタンスを割り当てる。
    static let shared = KeychainManager()
    
    // シングルトンであるためには、使用する時に直接インスタンス化をさせないようにするためにinitをprivate化してあげる。
    private init() {}
    
    
    func saveToken(token: Data, type: TokenType) -> Bool {
        let query = [
            kSecClass: kSecClassGenericPassword, // kSecClass: 保存するアイテムの種類を指定します。
            kSecAttrService: "com.amebaownd.yukifuruhashi.BoolReviewApp",     // kSecAttrService: 保存するアイテムを識別するための文字列。一般的にアプリ固有の文字列を利用します。
            kSecAttrAccount: type.rawValue, // kSecAttrAccount: 保存するアイテムをさらに細分化して識別するための文字列。
            kSecValueData: token // kSecValueData: 実際に保存したいデータ。Data型で保存している。
        ] as CFDictionary
        
        
        let matchingStatus = SecItemCopyMatching(query, nil)
        
        switch matchingStatus {
        case errSecItemNotFound:
            // データが存在しない場合は保存。
            // データを保存する：SecItemAdd　　実際にデータを保存するのは、SecItemAddメソッドです。引数に保存するCFDictionaryを渡し、その結果がOSStatus型で返ります。
            let status = SecItemAdd(query, nil)
            return status == noErr
            
        case errSecSuccess:
            // データが存在する場合は更新。
            SecItemUpdate(query, [kSecValueData as String: token] as CFDictionary)
            return true
            
        default:
            print("Failed to save data to keychain")
            return false
        }
    }
    
    
    
    
    
    func getToken(for type: TokenType) -> String? {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: "com.amebaownd.yukifuruhashi.BoolReviewApp",
            kSecAttrAccount: type.rawValue,
            kSecReturnData: kCFBooleanTrue as Any
        ] as CFDictionary
        
        var result: AnyObject?
                
        // データを取得する：SecItemCopyMatching　　キーチェーンに保存されているデータを取得するのはSecItemCopyMatchingメソッドです。
        SecItemCopyMatching(query, &result)
        
        if let data = (result as? Data) {
            return String(data: data, encoding: .utf8)
        } else {
            return nil
        }
    }
    
    
    
    
    
    func deleteToken(for type: TokenType) -> Bool {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: "com.amebaownd.yukifuruhashi.BoolReviewApp",
            kSecAttrAccount: type.rawValue,
            kSecReturnData: kCFBooleanTrue as Any
        ] as CFDictionary
                
        let status = SecItemDelete(query)
        
        return status == noErr
    }
    
    
    
    
}
