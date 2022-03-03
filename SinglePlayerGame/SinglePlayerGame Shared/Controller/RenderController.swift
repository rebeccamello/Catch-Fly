//
//  RenderController.swift
//  GameStructure
//
//  Created by Rebecca Mello on 03/03/22.
//

import Foundation
import SpriteKit

class RenderController {
    var scene: SKScene = SKScene()
    var playerNode: SKShapeNode = SKShapeNode()
    
    @discardableResult // pra tirar o warning se eu nao usasse o retorno
    func draw(_ player: Player) -> SKShapeNode {
        let node = SKShapeNode(circleOfRadius: player.size.width)
        node.position = player.position
        node.fillColor = player.color
        node.name = player.name
        scene.addChild(node)
        return node
    }
    
    func setUpScene() {
        scene.backgroundColor = .white
        
        scene.removeAllChildren()
        scene.removeAllActions()
    
        let player = GameController.shared.gameData.player!
        playerNode = draw(player)
    }
    
    func update(_ currentTime: TimeInterval) {
        playerNode.position = GameController.shared.gameData.player!.position
    }
}

