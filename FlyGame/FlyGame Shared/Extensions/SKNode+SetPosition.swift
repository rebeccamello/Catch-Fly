//
//  SKNode+SetPosition.swift
//  FlyGame
//
//  Created by Gui Reis on 12/04/22.
//

import SpriteKit

extension SKNode {
    
    /// Define as posições X, Y e Z
    internal func setPositions(x: CGFloat, y: CGFloat, z: CGFloat = 0) {
        self.position = CGPoint(x: x, y: y)
        self.zPosition = z
    }
}
