//
//  SKAction+.swift
//  FlyGame
//
//  Created by Gui Reis on 12/04/22.
//

import SpriteKit

extension SKAction {
    
    /// Cria uma animação a partir de uma imagem
    static func creatAnimation(by image: String, time: TimeInterval = 0.2) -> SKAction {
        let texture = SKTextureAtlas(named: image)
        let frames = texture.getFrames()
        
        let animation = SKAction.animate(
            with: frames,
            timePerFrame: TimeInterval(time),
            resize: false, restore: true)
        
        return SKAction.repeatForever(animation)
    }
}
