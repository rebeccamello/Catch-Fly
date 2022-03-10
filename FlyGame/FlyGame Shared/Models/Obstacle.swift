//
//  Obstacle.swift
//  FlyGame
//
//  Created by Nathalia do Valle Papst on 07/03/22.
//

import Foundation
import SpriteKit

class Obstacle {
    var positions:[CGFloat]
    var weight: Int
    var width: Int
    var assetName: String
    
    init(positions: [CGFloat], weight: Int, width: Int, assetName: String) {
        
        self.positions = positions
        self.width = width
        self.weight = weight
        self.assetName = assetName
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
