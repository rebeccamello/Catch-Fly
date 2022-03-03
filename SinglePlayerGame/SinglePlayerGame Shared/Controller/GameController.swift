//
//  GameController.swift
//  GameStructure
//
//  Created by Rebecca Mello on 03/03/22.
//

import Foundation
import SpriteKit

class GameController {
    
    static var shared: GameController = {
        let instance = GameController()
        return instance
    }()
    
    var gameData: GameData
    var renderer: RenderController
    
    private init(){
        // inicializa os modelos de dados
        // estado inicial do meu jogador
        let player = Player(name: "Becca",
                            color: .green,
                            position: CGPoint(x: 0, y: 0),
                            size: CGSize(width: 50, height: 50)
        )
        gameData = GameData(player: player)
        
        // inicializa o renderizador
        renderer = RenderController()
    }
    
    func setScene(scene: SKScene) {
        renderer.scene = scene
    }
    
    func setUpScene() {
        // atualiza os modelos para a condiguracao inicial
        let player = GameController.shared.gameData.player!
        player.position = CGPoint(x: renderer.scene.size.width/2, y: renderer.scene.size.height/2)
        
        // desenha o modelo
        renderer.setUpScene()
    }
    
    func update(_ currentTime: TimeInterval) {
        // atualiza o modelo
        gameData.player?.position.x += 1
        
        // atualiza os desenhos
        renderer.update(currentTime)
    }
    
    // MARK: Input
    func movePlayerUp() {
        gameData.player?.position.y += 10
    }
}
