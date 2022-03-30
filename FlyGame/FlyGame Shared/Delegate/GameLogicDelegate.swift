//
//  GameLogicDelegate.swift
//  FlyGame
//
//  Created by Nathalia do Valle Papst on 07/03/22.
//

import Foundation
import SpriteKit

protocol GameLogicDelegate: AnyObject {
    func getSoundButton() -> SKButtonNode
    
    func getMusicButton() -> SKButtonNode
    
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
    
    func getResumeButton() -> SKButtonNode
    
    func getHomeButton() -> SKButtonNode
    
    func getRestartButton() -> SKButtonNode
    
    func restartGame()
    
    func getScenario() -> SKSpriteNode
    
    func getScenario2() -> SKSpriteNode
    
    func getScenarioTextures() -> [SKTexture]
 
    func createCoin()
    
    func getPlusTwoLabel() -> SKLabelNode
}
