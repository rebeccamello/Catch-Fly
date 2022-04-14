//
//  GameLogicDelegate.swift
//  FlyGame
//
//  Created by Nathalia do Valle Papst on 07/03/22.
//

import SpriteKit

protocol GameLogicDelegate: AnyObject {
    func resumeGame()
    
    func pauseGame()
    
    func drawScore(score: Int)
    
    func goToHome()
    
    func soundAction()
    
    func musicAction()
    
    func createObstacle(obstacle: Obstacle)
    
    func goToGameOverScene()
    
    func movePlayer(direction: Direction)
    
    func pausedStatus() -> Bool
    
    func getButtons() -> [SKButtonNode]
    
    func restartGame()
    
    func getScenario() -> [SKSpriteNode]
     
    /// Cria um nova moeda
    func createCoin()
    
    /// Lida com o contato entre dois nodes
    func contact(with contact: SKPhysicsContact)
    
    /// Defini a visibilidade da Label
    func setCoinScoreLabelVisibility(for status: Bool)
    
    /// Ativa uma ação na Label que mostra a pontuação ganha da moeda
    func runCoinScoreLabelAction(with action: SKAction)
}
