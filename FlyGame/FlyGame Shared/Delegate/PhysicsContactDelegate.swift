//
//  PhysicsContactDelegate.swift
//  FlyGame
//
//  Created by Gui Reis on 14/04/22.
//

import SpriteKit

class PhysicsContactDelegate: NSObject, SKPhysicsContactDelegate {
    
    /* MARK: - Atributos */
    weak var gameSceneDelegate: GameLogicDelegate?
    
    /* MARK: - Delegate */
    
    func didBegin(_ contact: SKPhysicsContact) {
        print("Entei no DidBegin")
        self.gameSceneDelegate?.contact(with: contact)
    }
}
