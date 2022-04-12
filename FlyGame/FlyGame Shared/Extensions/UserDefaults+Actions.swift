//
//  UserDefaults+Actions.swift
//  FlyGame
//
//  Created by Gui Reis on 12/04/22.
//

import Foundation

extension UserDefaults {
    
    internal static func updateValue(in key: UserDefaultsKeys, with value: Any) {
        UserDefaults.standard.set(value, forKey: key.description)
    }
    
    internal static func getIntValue(with key: UserDefaultsKeys) -> Int {
        return UserDefaults.standard.integer(forKey: key.description)
    }
    
    internal static func getBoolValue(with key: UserDefaultsKeys) -> Bool {
        return UserDefaults.standard.bool(forKey: key.description)
    }
}
