//
//  Obstacle.swift
//  FlyGame
//
//  Created by Nathalia do Valle Papst on 07/03/22.
//

import SpriteKit

struct Obstacle {
    let lanePosition: Int
    let weight: Int
    let width: Int
    let assetName: String
    let physicsBody: SKPhysicsBody
    
    init(lanePosition: Int, weight: Int, width: Int, image: String, laneSize: Int) {
        self.lanePosition = lanePosition
        self.weight = weight
        self.width = width
        self.assetName = image
        self.physicsBody = SKPhysicsBody(
            texture: SKTexture(imageNamed: image),
            size: CGSize(
                width: laneSize * width,
                height: laneSize * weight
            )
        )
    }
}
