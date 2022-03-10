//
//  Obstacle.swift
//  FlyGame
//
//  Created by Nathalia do Valle Papst on 07/03/22.
//

import Foundation
import SpriteKit

class Obstacle {
    var lanePosition: CGFloat
    var weight: Int
    var width: Int
    var assetName: String
    
    init(lanePosition: CGFloat, weight: Int, width: Int, assetName: String) {
        
        self.lanePosition = lanePosition
        self.width = width
        self.weight = weight
        self.assetName = assetName
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
