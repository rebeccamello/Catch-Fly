//
//  UserDefaultsKeys.swift
//  FlyGame
//
//  Created by Gui Reis on 12/04/22.
//

enum UserDefaultsKeys: CustomStringConvertible {
    case firstTimeOnApp
    case highScore
    case gameScore
    case sound
    case music
    case tutorial
    
    var description: String {
        switch self {
        case .firstTimeOnApp: return "firstTimeOpenApp"
        case .tutorial: return "playerFirstTime"
        case .highScore: return "highscore"
        case .gameScore: return "currentScore"
        case .sound: return "sound"
        case .music: return "music"
        }
    }
}
