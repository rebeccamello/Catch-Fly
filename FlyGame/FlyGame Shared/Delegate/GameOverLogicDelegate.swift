//
//  GameOverLogicDelegate.swift
//  FlyGame
//
//  Created by Nathalia do Valle Papst on 07/03/22.
//

import Foundation
import SpriteKit

protocol GameOverLogicDelegate: AnyObject {
    func restartGame()
    
    func getButtons() -> [SKButtonNode]
    
    func goToMenu() 
}
