//
//  ObstacleFetcher.swift
//  FlyGame
//
//  Created by Caroline Taus on 11/03/22.
//

import Foundation
import CoreGraphics

class ObstacleFetcher {
    private var obstacles: [Obstacle] = [
        Obstacle(lanePosition: 2, weight: 2, width: 2, assetName: "comodaVaso"),
        Obstacle(lanePosition: 5, weight: 1, width: 1, assetName: "lustre"),
        Obstacle(lanePosition: 1, weight: 1, width: 1, assetName: "globo"),
        Obstacle(lanePosition: 1, weight: 1, width: 1, assetName: "cadeira"),
        Obstacle(lanePosition: 1, weight: 1, width: 1, assetName: "banco"),
        Obstacle(lanePosition: 1, weight: 1, width: 1, assetName: "vaso"),
        Obstacle(lanePosition: 1, weight: 1, width: 2, assetName: "comoda"),
        Obstacle(lanePosition: 1, weight: 1, width: 2, assetName: "mesa"),
        Obstacle(lanePosition: 3, weight: 1, width: 2, assetName: "estanteLivros"),
        Obstacle(lanePosition: 3, weight: 1, width: 2, assetName: "estanteVasos"),
        Obstacle(lanePosition: 5, weight: 1, width: 2, assetName: "estanteLivros"),
        Obstacle(lanePosition: 5, weight: 1, width: 2, assetName: "estanteVasos"),
        Obstacle(lanePosition: 4, weight: 2, width: 1, assetName: "estanteDeCha"),
        Obstacle(lanePosition: 2, weight: 2, width: 1, assetName: "vovo"),
        Obstacle(lanePosition: 2, weight: 2, width: 2, assetName: "piano"),
        Obstacle(lanePosition: 4, weight: 2, width: 2, assetName: "armario"),
        Obstacle(lanePosition: 2, weight: 2, width: 1, assetName: "bancoVaso"),
        Obstacle(lanePosition: 2, weight: 2, width: 2, assetName: "mesaVaso"),
        Obstacle(lanePosition: 5, weight: 1, width: 1, assetName: "lustre2"),
        Obstacle(lanePosition: 5, weight: 1, width: 1, assetName: "lustre3"),
        Obstacle(lanePosition: 3, weight: 1, width: 1, assetName: "relogio"),
        Obstacle(lanePosition: 5, weight: 1, width: 1, assetName: "relogio"),
        Obstacle(lanePosition: 3, weight: 1, width: 1, assetName: "vasoAzul"),
        Obstacle(lanePosition: 3, weight: 1, width: 1, assetName: "flor")
    ]
    
    func fetch(lane: Int) -> Obstacle {
        let filteredObstacles = obstacles.filter { obstacle in
            (obstacle.lanePosition == lane)
        }
        let index = randomizer(min: 0, max: filteredObstacles.count-1)
        return filteredObstacles[index]
    }
}
