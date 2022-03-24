//
//  Obstacle.swift
//  FlyGame
//
//  Created by Nathalia do Valle Papst on 07/03/22.
//

import class SpriteKit.SKPhysicsBody

struct Obstacle {
    let lanePosition: Int
    let weight: Int
    let width: Int
    let assetName: String
    let physicsBody: SKPhysicsBody
}
