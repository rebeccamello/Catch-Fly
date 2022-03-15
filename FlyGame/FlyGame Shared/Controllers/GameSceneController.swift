//
//  GameSceneController.swift
//  POCScenes
//
//  Created by Rebecca Mello on 07/03/22.
//

import Foundation
import UIKit
import GameplayKit

func randomizer(min: Int, max: Int) -> Int {
    let randomizer = GKRandomDistribution(lowestValue: min, highestValue: max)
    let randomIndex = randomizer.nextInt()
    return randomIndex
}

class GameSceneController {
    
    weak var gameDelegate: GameLogicDelegate?
    var timer = Timer()
    var timeCounter = 0
    var count: CGFloat = 10
    var fetcher = ObstacleFetcher()
    
    private let maxWeight = 2
    
    func movePlayer(direction: Direction, position: Int) {
        var newPosition = position
        
        if direction == .up {
            if position != 5 {
                newPosition += 2
            }
        } else {
            if position != 1 {
                newPosition -= 2
            }
        }
        
        gameDelegate?.movePlayer(position: newPosition)
    }
    
    func startUp() {
        timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(obstacleSpeed), userInfo: nil, repeats: true)
    }
    
    @objc func obstacleSpeed(speed: CGFloat) {
        timeCounter += 1
        var newSpeed = count
        
        //MARK: AUMENTAR O INTERVALO DE TEMPO
        if timeCounter >= 30 {
            timeCounter = 0
            newSpeed += 0.1
            count += 1
        }
        gameDelegate?.obstacleSpeed(speed: newSpeed)
    }
    
    func chooseObstacle() -> [Obstacle] {
        /*
         1. decidir peso
         2. quantidade de objetos
         3. decidir as lanes
         */
        let weight: Int = randomizer(min: 1, max: 2)
        let quantity = chooseObstacleQuantity(for: weight)
        let lanes = chooseObstacleLane(for: weight, quantity: quantity)
        
        return lanes.map { fetcher.fetch(lane: $0) } // transforma a lista de lanes em lista de obstacles
    }
    
    private func chooseObstacleQuantity(for weight: Int) -> Int {
        if (weight == 1) {
            return 1
        } else {
            let quantity: Int = randomizer(min: 1, max: 2)
            return quantity
        }
    }
    
    private func chooseObstacleLane(for weight: Int, quantity: Int) -> [Int] {
        var lanes: [Int]
        
        if weight == 2 && quantity == 1 {
            lanes = [2, 4]
        } else {
            lanes = [1, 3, 5]
        }
        
        lanes.shuffle() // da um shuffle
        
        return Array(0..<quantity).map { lanes[$0] } //cria um array de tam das lanes e pega o primeiro ou primeiro e segundo
    }
    
    func update(currentTime: TimeInterval) {
        
    }
    
    func tearDown() {
        timeCounter = 0
        timer.invalidate()
    }
}


