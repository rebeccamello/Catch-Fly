//
//  ObstacleFetcher.swift
//  FlyGame
//
//  Created by Caroline Taus on 11/03/22.
//

import CoreGraphics
import SpriteKit
import GameplayKit

class ObstacleFetcher {
    private var obstacles: [Obstacle]
    
    init() {
        let screenSize: CGSize = .screenSize()
        let laneSize = Int(screenSize.height/3)
        
        self.obstacles = [
            // 1x1
            Obstacle(lanePosition: 5, weight: 1, width: 1, image: "lustre2", laneSize: laneSize),
            Obstacle(lanePosition: 5, weight: 1, width: 1, image: "lustre3", laneSize: laneSize),
            Obstacle(lanePosition: 3, weight: 1, width: 1, image: "relogio", laneSize: laneSize),
            Obstacle(lanePosition: 5, weight: 1, width: 1, image: "relogio", laneSize: laneSize),
            Obstacle(lanePosition: 3, weight: 1, width: 1, image: "vasoAzul", laneSize: laneSize),
            Obstacle(lanePosition: 3, weight: 1, width: 1, image: "flor", laneSize: laneSize),
            Obstacle(lanePosition: 5, weight: 1, width: 1, image: "lustre", laneSize: laneSize),
            Obstacle(lanePosition: 1, weight: 1, width: 1, image: "globo", laneSize: laneSize),
            Obstacle(lanePosition: 1, weight: 1, width: 1, image: "cadeira", laneSize: laneSize),
            Obstacle(lanePosition: 1, weight: 1, width: 1, image: "banco", laneSize: laneSize),
            Obstacle(lanePosition: 1, weight: 1, width: 1, image: "vaso", laneSize: laneSize),
            
            // 1x2
            Obstacle(lanePosition: 4, weight: 2, width: 1, image: "estanteDeCha", laneSize: laneSize),
            Obstacle(lanePosition: 2, weight: 2, width: 1, image: "vovo", laneSize: laneSize),
            Obstacle(lanePosition: 2, weight: 2, width: 1, image: "bancoVaso", laneSize: laneSize),
            
            // 2x1
            Obstacle(lanePosition: 1, weight: 1, width: 2, image: "comoda", laneSize: laneSize),
            Obstacle(lanePosition: 1, weight: 1, width: 2, image: "mesa", laneSize: laneSize),
            Obstacle(lanePosition: 3, weight: 1, width: 2, image: "estanteLivros", laneSize: laneSize),
            Obstacle(lanePosition: 3, weight: 1, width: 2, image: "estanteVasos", laneSize: laneSize),
            Obstacle(lanePosition: 5, weight: 1, width: 2, image: "estanteLivros", laneSize: laneSize),
            Obstacle(lanePosition: 5, weight: 1, width: 2, image: "estanteVasos", laneSize: laneSize),
            
            // 2x2
            Obstacle(lanePosition: 2, weight: 2, width: 2, image: "piano", laneSize: laneSize),
            Obstacle(lanePosition: 4, weight: 2, width: 2, image: "armario", laneSize: laneSize),
            Obstacle(lanePosition: 2, weight: 2, width: 2, image: "mesaVaso", laneSize: laneSize),
            Obstacle(lanePosition: 2, weight: 2, width: 2, image: "comodaVaso", laneSize: laneSize)
        ]
    }
    
    func fetch(lane: Int) -> Obstacle {
        let filteredObstacles = obstacles.filter { obstacle in
            (obstacle.lanePosition == lane)
        }
        let index = randomizer(min: 0, max: filteredObstacles.count-1)
        return filteredObstacles[index]
    }
    
    func randomizer(min: Int, max: Int) -> Int {
        let randomizer = GKRandomDistribution(lowestValue: min, highestValue: max)
        let randomIndex = randomizer.nextInt()
        return randomIndex
    }
}
