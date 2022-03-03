//
//  Player.swift
//  GameStructure
//
//  Created by Rebecca Mello on 03/03/22.
//

import Foundation
import SpriteKit

class Player: CustomStringConvertible {
    
    lazy var description: String = {
        return "Player name: \(name), position: \(position)"
    }()
    
    var name: String
    var color: SKColor
    var position: CGPoint
    var size: CGSize
    
    init(name: String, color: SKColor, position: CGPoint, size: CGSize) {
        self.name = name
        self.color = color
        self.position = position
        self.size = size
    }
}
