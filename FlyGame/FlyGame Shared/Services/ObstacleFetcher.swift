//
//  ObstacleFetcher.swift
//  FlyGame
//
//  Created by Caroline Taus on 11/03/22.
//

import CoreGraphics
import SpriteKit

class ObstacleFetcher {
    private var obstacles: [Obstacle]
    
    init() {
        let screenSize: CGSize = .screenSize()
        let laneHeight = screenSize.height/3
        
        self.obstacles = [
            Obstacle(lanePosition: 2, weight: 2, width: 2, assetName: "comodaVaso", physicsBody: SKPhysicsBody(texture: SKTexture(imageNamed: "comodaVaso"), size: CGSize(width: laneHeight*2, height: laneHeight*2))),
            Obstacle(lanePosition: 5, weight: 1, width: 1, assetName: "lustre", physicsBody: SKPhysicsBody(texture: SKTexture(imageNamed: "lustre"), size: CGSize(width: laneHeight, height: laneHeight))),
            Obstacle(lanePosition: 1, weight: 1, width: 1, assetName: "globo", physicsBody: SKPhysicsBody(texture: SKTexture(imageNamed: "globo"), size: CGSize(width: laneHeight, height: laneHeight))),
            Obstacle(lanePosition: 1, weight: 1, width: 1, assetName: "cadeira", physicsBody: SKPhysicsBody(texture: SKTexture(imageNamed: "cadeira"), size: CGSize(width: laneHeight, height: laneHeight))),
            Obstacle(lanePosition: 1, weight: 1, width: 1, assetName: "banco", physicsBody: SKPhysicsBody(texture: SKTexture(imageNamed: "banco"), size: CGSize(width: laneHeight, height: laneHeight))),
            Obstacle(lanePosition: 1, weight: 1, width: 1, assetName: "vaso", physicsBody: SKPhysicsBody(texture: SKTexture(imageNamed: "vaso"), size: CGSize(width: laneHeight, height: laneHeight))),
            Obstacle(lanePosition: 1, weight: 1, width: 2, assetName: "comoda", physicsBody: SKPhysicsBody(texture: SKTexture(imageNamed: "comoda"), size: CGSize(width: laneHeight*2, height: laneHeight))),
            Obstacle(lanePosition: 1, weight: 1, width: 2, assetName: "mesa", physicsBody: SKPhysicsBody(texture: SKTexture(imageNamed: "mesa"), size: CGSize(width: laneHeight*2, height: laneHeight))),
            Obstacle(lanePosition: 3, weight: 1, width: 2, assetName: "estanteLivros", physicsBody: SKPhysicsBody(texture: SKTexture(imageNamed: "estanteLivros"), size: CGSize(width: laneHeight*2, height: laneHeight))),
            Obstacle(lanePosition: 3, weight: 1, width: 2, assetName: "estanteVasos", physicsBody: SKPhysicsBody(texture: SKTexture(imageNamed: "estanteVasos"), size: CGSize(width: laneHeight*2, height: laneHeight))),
            Obstacle(lanePosition: 5, weight: 1, width: 2, assetName: "estanteLivros", physicsBody: SKPhysicsBody(texture: SKTexture(imageNamed: "estanteLivros"), size: CGSize(width: laneHeight*2, height: laneHeight))),
            Obstacle(lanePosition: 5, weight: 1, width: 2, assetName: "estanteVasos", physicsBody: SKPhysicsBody(texture: SKTexture(imageNamed: "estanteVasos"), size: CGSize(width: laneHeight*2, height: laneHeight))),
            Obstacle(lanePosition: 4, weight: 2, width: 1, assetName: "estanteDeCha", physicsBody: SKPhysicsBody(texture: SKTexture(imageNamed: "estanteDeCha"), size: CGSize(width: laneHeight, height: laneHeight*2))),
            Obstacle(lanePosition: 2, weight: 2, width: 1, assetName: "vovo", physicsBody: SKPhysicsBody(texture: SKTexture(imageNamed: "vovo"), size: CGSize(width: laneHeight, height: laneHeight*2))),
            
            Obstacle(lanePosition: 2, weight: 2, width: 2, assetName: "piano", physicsBody: SKPhysicsBody(texture: SKTexture(imageNamed: "piano"), size: CGSize(width: laneHeight*2, height: laneHeight*2))),
            
            Obstacle(lanePosition: 4, weight: 2, width: 2, assetName: "armario", physicsBody: SKPhysicsBody(texture: SKTexture(imageNamed: "armario"), size: CGSize(width: laneHeight*2, height: laneHeight*2))),
            Obstacle(lanePosition: 2, weight: 2, width: 1, assetName: "bancoVaso", physicsBody: SKPhysicsBody(texture: SKTexture(imageNamed: "bancoVaso"), size: CGSize(width: laneHeight, height: laneHeight*2))),
            Obstacle(lanePosition: 2, weight: 2, width: 2, assetName: "mesaVaso", physicsBody: SKPhysicsBody(texture: SKTexture(imageNamed: "mesaVaso"), size: CGSize(width: laneHeight*2, height: laneHeight*2))),
            Obstacle(lanePosition: 5, weight: 1, width: 1, assetName: "lustre2", physicsBody: SKPhysicsBody(texture: SKTexture(imageNamed: "lustre2"), size: CGSize(width: laneHeight, height: laneHeight))),
            Obstacle(lanePosition: 5, weight: 1, width: 1, assetName: "lustre3", physicsBody: SKPhysicsBody(texture: SKTexture(imageNamed: "lustre3"), size: CGSize(width: laneHeight, height: laneHeight))),
            Obstacle(lanePosition: 3, weight: 1, width: 1, assetName: "relogio", physicsBody: SKPhysicsBody(texture: SKTexture(imageNamed: "relogio"), size: CGSize(width: laneHeight, height: laneHeight))),
            Obstacle(lanePosition: 5, weight: 1, width: 1, assetName: "relogio", physicsBody: SKPhysicsBody(texture: SKTexture(imageNamed: "relogio"), size: CGSize(width: laneHeight, height: laneHeight))),
            Obstacle(lanePosition: 3, weight: 1, width: 1, assetName: "vasoAzul", physicsBody: SKPhysicsBody(texture: SKTexture(imageNamed: "vasoAzul"), size: CGSize(width: laneHeight, height: laneHeight))),
            Obstacle(lanePosition: 3, weight: 1, width: 1, assetName: "flor", physicsBody: SKPhysicsBody(texture: SKTexture(imageNamed: "flor"), size: CGSize(width: laneHeight, height: laneHeight)))
        ]
    }
    
    func fetch(lane: Int) -> Obstacle {
        let filteredObstacles = obstacles.filter { obstacle in
            (obstacle.lanePosition == lane)
        }
        let index = randomizer(min: 0, max: filteredObstacles.count-1)
        return filteredObstacles[index]
    }
}
