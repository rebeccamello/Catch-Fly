//
//  GameData.swift
//  GameStructure
//
//  Created by Rebecca Mello on 03/03/22.
//

import Foundation

class GameData {
    
    var player: Player?
    var score: Int = 0
    
    init(player: Player) {
        self.player = player
    }
}
