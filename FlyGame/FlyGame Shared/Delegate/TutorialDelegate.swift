//
//  TutorialDelegate.swift
//  FlyGame
//
//  Created by Gabriele Namie on 30/03/22.
//

import Foundation
import SpriteKit

protocol TutorialDelegate: AnyObject {
    
    func movePlayer(direction: Direction)
    
    func createObstacle(obstacle: Obstacle)
    
    func moveObstacle()
    
    func moveObstacleOffScreen()
    
    func getNodes() -> [SKSpriteNode]
    
    func addNode(node: SKSpriteNode)
    
    func getLabelNode() -> SKLabelNode
    
    func addLabelNode(label: SKLabelNode)
    
    func getScreenSize() -> CGSize 
}
