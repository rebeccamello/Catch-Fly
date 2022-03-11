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
        Obstacle(lanePosition: 5, weight: 1, width: 1, assetName: "lustre")
    ]
    
    func fetch(lane: Int, weight: Int) -> Obstacle {
        let filteredObstacles = obstacles.filter { obstacle in
            (obstacle.lanePosition == lane)
            && (weight == obstacle.weight)
        }
        let index = randomizer(min: 0, max: filteredObstacles.count-1)
        return filteredObstacles[index]
    }
}

let weight1assets: [[String]] = [["cadeira", "comoda", "mesa", "vaso", "banquinho"],["estanteVasos", "estateLivros"],["lustre"]] // matriz [[obstacs posição1], [posição3], [posição5]]
let weight2assets: [[String]] = [["comodaVasoGlobo", "piano", "vovo", "banquinhoVaso"],["estanteXicaras", "armarioCopos"]]
