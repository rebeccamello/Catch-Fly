//
//  SKSpriteNode+setupPhysics.swift
//  FlyGame
//
//  Created by Gui Reis on 13/04/22.
//

import SpriteKit

extension SKSpriteNode {
    
    /// Cria as físicas de acordo com o típo do Node
    internal func setupPhysics() {
        // Toda vez que muda as dimensões da tela precisa atualizar o tamanho da física
        if self.name == "Fly" {
            self.physicsBody = SKPhysicsBody(texture: self.texture!, size: self.size)
        }
        
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.isDynamic = false
        
        switch self.name {
        case "Fly":
            self.physicsBody?.isDynamic = true
            self.physicsBody?.allowsRotation = false
            self.physicsBody?.categoryBitMask = CollisionBitMask.flyCategory
            self.physicsBody?.collisionBitMask = CollisionBitMask.obstaclesCategory
            self.physicsBody?.contactTestBitMask = CollisionBitMask.coinCategory | CollisionBitMask.obstaclesCategory
            print("Criei as físicas da Fly")
            
        case "Enemy":
            self.physicsBody?.linearDamping = 0
            self.physicsBody?.friction = 0
            self.physicsBody?.categoryBitMask = CollisionBitMask.obstaclesCategory
            self.physicsBody?.collisionBitMask = CollisionBitMask.flyCategory
            self.physicsBody?.contactTestBitMask = CollisionBitMask.flyCategory
            print("Criei as físicas do Obstáculo")
        
        case "Coin":
            self.physicsBody?.categoryBitMask = CollisionBitMask.coinCategory
            self.physicsBody?.collisionBitMask = 0
            self.physicsBody?.contactTestBitMask = CollisionBitMask.flyCategory
            print("Criei as físicas da Moeda")
        
        default: break
        }
    }
}
