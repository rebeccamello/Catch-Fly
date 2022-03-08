//
//  GameOverScene.swift
//  FlyGame
//
//  Created by Nathalia do Valle Papst on 07/03/22.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene {
    
    class func newGameScene() -> GameOverScene {
        let scene = GameOverScene()
        scene.scaleMode = .resizeFill
        return scene
    }

    func setUpScene() {
        
    }
    
    override func didMove(to view: SKView) {
        self.setUpScene()
    }
    
    override func didChangeSize(_ oldSize: CGSize) {
        
    }
}

extension GameOverScene: GameOverLogicDelegate {
    
    func restartGame() {
       
    }
    
    func goToMenu() {
       
    }
}

