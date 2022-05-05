//
//  Achievments.swift
//  FlyGame
//
//  Created by Gui Reis on 05/05/22.
//

enum Achievments: CustomStringConvertible {
    case score25
    case score60
    case score100
    case score125
    case score150
    case noCoins
    case coin5
    case coin12
    case grandma
    
    var description: String {
        switch self {
        case .score25: return "firstPointMilestoneID"
        case .score60: return "secondPointMilestoneID"
        case .score100: return "thirdPointMilestoneID"
        case .score125: return "fourthPointMilestoneID"
        case .score150: return "fifthPointMilestoneID"
        case .noCoins: return "noCoinsInRunID"
        case .coin5: return "firstCoinsInRunID"
        case .coin12: return "secondCoinsInRunID"
        case .grandma: return "crashedGrandmaID"
        }
    }
}
