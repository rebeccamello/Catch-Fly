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
        timer = Timer.scheduledTimer(timeInterval: 0.08, target: self, selector: #selector(obstacleSpeed), userInfo: nil, repeats: true)
    }
    
    @objc func obstacleSpeed(speed: CGFloat) {
        timeCounter += 1
        var newSpeed = count
        
        //MARK: AUMENTAR O INTERVALO DE TEMPO
        if timeCounter >= 5 {
            timeCounter = 0
            newSpeed += 1
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
        print(weight, quantity, lanes)
        
        return lanes.map { fetcher.fetch(lane: $0, weight: weight) } // transforma a lista de lanes em lista de obstacles
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
        
        if weight == 2 {
            lanes = [2, 4]
        } else {
            lanes = [1, 3, 5]
        }
        
        lanes.shuffle() // da um shuffle
        
        return Array(0..<quantity).map { lanes[$0] } //cria um array de tam das lanes e pega o primeiro ou primeiro e segundo
    }
    
    
//    func chooseObstacle() -> [String] {
//        var chosenObstacles: [String] = []
//
//
//        // decidir se o obstáculo será de peso 1 ou 2
//        let weight: Int = randomizer(min: 1, max: 2)
//        if (weight == 1) { // se for peso 1
//            // decidir qual será a posição
//            let position: Int = randomizer(min: 0, max: 2)
//            //decidir qual será o obstáculo
//            var obs: Int = randomizer(min: 0, max: weight1assets[position].count-1)
//            chosenObstacles.append(weight1assets[position][obs])
//
//            // decidir se terá mais um objeto
//            let twoObs: Int = randomizer(min: 1, max: 2)
//            if (twoObs == 2) { // terá dois obstaculos
//                //decidir de qual lane será o outro obs
//
//                let otherLane: Int = randomizer(min: 1, max: 2)
//                if (position == 0) {
////                    let otherLanePos
//
//                }
//
//
//
//                obs = randomizer(min: 0, max: weight1assets[otherLane].count-1)
//                chosenObstacles.append(weight1assets[otherLane][obs])
//            }
//
//
//        }
//        else { // se for peso 2
//            // decide a lane do obs
//            let position: Int = randomizer(min: 0, max: 1)
//            let obs: Int = randomizer(min: 0, max: weight2assets[position].count-1)
//            chosenObstacles.append(weight2assets[position][obs])
//        }
//
//        return chosenObstacles
//    }
    
    
    
    func update(currentTime: TimeInterval) {
        
    }
    
    func tearDown() {
        timer.invalidate()
    }
}


