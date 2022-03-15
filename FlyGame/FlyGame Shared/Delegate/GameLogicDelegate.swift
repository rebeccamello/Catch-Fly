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
    
    func gameOver()
    
    func goToHome()
    
    func retryGame()
    
    func sound()
    
    func music()
    
    func movePlayer(position: Int)
    
    func obstacleSpeed(speed: CGFloat)
    
    func createObstacle(obstacle: Obstacle)
}


