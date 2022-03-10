//
//  GameOverScene.swift
//  FlyGame
//
//  Created by Nathalia do Valle Papst on 07/03/22.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene {
    
    lazy var label: SKLabelNode = {
        var label = SKLabelNode()
         label.fontColor = .blue
         label.numberOfLines = 0
         label.fontSize = 60
         label.text = "GameOver scene"
         
         return label
    }()
    
    class func newGameScene() -> GameOverScene {
        let scene = GameOverScene()
        scene.scaleMode = .resizeFill
        return scene
    }

    func setUpScene() {
        self.addChild(label)
    }
    
    override func didMove(to view: SKView) {
        self.setUpScene()
    }
    
    override func didChangeSize(_ oldSize: CGSize) {
        label.position = CGPoint(x: size.width/2, y: size.height/2)
    }
}

extension GameOverScene: GameOverLogicDelegate {
    
    func restartGame() {
       
    }
    
    func goToMenu() {
       
    }
}

