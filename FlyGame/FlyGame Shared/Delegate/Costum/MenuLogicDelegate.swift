//
//  MenuLogicDelegate.swift
//  FlyGame
//
//  Created by Nathalia do Valle Papst on 07/03/22.
//
// swiftlint:disable class_delegate_protocol

import class SpriteKit.SKScene

protocol MenuLogicDelegate {
    func goToGameCenter()
    
    func getButtons() -> [SKButtonNode]
    
    func getTutorialStatus() -> Bool
    
    func presentScene(scene: SKScene)
    
    func goToGameScene()
}
