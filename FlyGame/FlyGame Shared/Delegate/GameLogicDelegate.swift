//
//  GameLogicDelegate.swift
//  FlyGame
//
//  Created by Nathalia do Valle Papst on 07/03/22.
//

import Foundation
import SpriteKit

protocol GameLogicDelegate: AnyObject {
    func resumeGame()
    
    func pauseGame()
    
    func drawScore(score: Int)
    
    func goToHome()
    
    func soundAction()
    
    func musicAction()
    
    func createObstacle(obstacle: Obstacle)
    
    func setPhysicsWorldDelegate()
    
    func goToGameOverScene()
    
    func movePlayer(direction: Direction)
    
    func pausedStatus() -> Bool
    
    func getButtons() -> [SKButtonNode]
    
    func restartGame()
    
    func getScenario() -> [SKSpriteNode]
    
    func getScenarioTextures() -> [SKTexture]
 
    func createCoin()
    
    func getPlusTwoLabel() -> SKLabelNode
}
