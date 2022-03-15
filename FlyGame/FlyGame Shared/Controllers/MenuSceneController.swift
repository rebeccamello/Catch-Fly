//
//  MenuSceneController.swift
//  FlyGame
//
//  Created by Nathalia do Valle Papst on 07/03/22.
//

import Foundation
import SpriteKit

class MenuSceneController {
    
    weak var menuDelegate: MenuLogicDelegate?
    var soundOn: Bool = true
    var musicOn: Bool = true
    
    func playGame() {
        let scene = GameScene.newGameScene()
        menuDelegate?.playGame(scene: scene)
    }
    
    func toggleSound() {
        
        if let node = menuDelegate?.toggleSound() {
            let texture: [SKTexture] = [SKTexture(imageNamed: "somBotao"),
                                        SKTexture(imageNamed: "somDesligadoBotao")]
            soundOn.toggle()
            
            if soundOn {
                node.image.texture = texture[0]
            } else {
                node.image.texture = texture[1]
            }
        } else {
            return
            
        }
    }
    
    func toggleMusic() {
        
        if let node = menuDelegate?.toggleMusic() {
            let texture: [SKTexture] = [SKTexture(imageNamed: "musicaBotao"),
                                        SKTexture(imageNamed: "musicaDesligadoBotao")]
            
            musicOn.toggle()
            
            if musicOn {
                node.image.texture = texture[0]
            } else {
                node.image.texture = texture[1]
            }
        } else {
            return
            
        }
    }
    
}
