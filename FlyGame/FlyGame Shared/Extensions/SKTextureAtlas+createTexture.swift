//
//  SKTextureAtlas+createTexture.swift
//  FlyGame
//
//  Created by Gui Reis on 12/04/22.
//

import SpriteKit

extension SKTextureAtlas {
    
    internal func getFrames() -> [SKTexture] {
        var frames: [SKTexture] = []
        for name in self.textureNames {
            frames.append(self.textureNamed(name))
        }
        return frames
    }
}
