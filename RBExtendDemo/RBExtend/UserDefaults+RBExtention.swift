//
//  UserDefaults+RBExtention.swift
//  RBExtendDemo
//
//  Created by RanBin on 2021/9/4.
//

import Foundation

// MARK: - UserDefaults常用封装
protocol UserDefaultsSettable {
    associatedtype defaultKeys: RawRepresentable
}


extension UserDefaultsSettable where defaultKeys.RawValue==String {
    
    static func set(value: String?, forKey key: defaultKeys) {
        let aKey = key.rawValue
        UserDefaults.standard.set(value, forKey: aKey)
    }
    static func string(forKey key: defaultKeys) -> String? {
        let aKey = key.rawValue
        return UserDefaults.standard.string(forKey: aKey)
    }
}


extension UserDefaultsSettable where defaultKeys.RawValue==String {
    
    static func set(value: Any?, forKey key: defaultKeys) {
        let aKey = key.rawValue
        UserDefaults.standard.set(value, forKey: aKey)
    }
    static func object(forKey key: defaultKeys) -> Any? {
        let aKey = key.rawValue
        return UserDefaults.standard.dictionary(forKey: aKey)
    }
}



/**
 使用：
 
 UserDefaults.LoginInfo.set(value: "token", forKey: .token)
 UserDefaults.LoginInfo.string(forKey: .token)
 
 */
extension UserDefaults {
    
    // 登录信息
    struct LoginInfo: UserDefaultsSettable {
        enum defaultKeys: String {
            case token
            case userId
            case userName
            case loginStatus
            
        }
    }
    
    // 账户信息
    struct AccountInfo: UserDefaultsSettable {
        enum defaultKeys: String {
            case history
            case user
        }
    }
    
    // APP信息
    struct APPInfo: UserDefaultsSettable {
        enum defaultKeys: String {
            case version
            case isFirstLogin
        }
    }
    
    
}
