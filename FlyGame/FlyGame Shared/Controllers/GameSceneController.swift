//
//  GameSceneController.swift
//  POCScenes
//
//  Created by Rebecca Mello on 07/03/22.
//

import Foundation
import UIKit

class GameSceneController {
    
    weak var gameDelegate: GameLogicDelegate?
    var timer = Timer()
    var timeCounter = 0
    var count: CGFloat = 10
    
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
        print(speed)
        timeCounter += 1
        var newSpeed = count
        
        //MARK: AUMENTAR O INTERVALO DE TEMPO
        if timeCounter >= 5 {
            print("entrou")
            timeCounter = 0
            newSpeed += 1
            count += 1
        }
        print("newspeed: \(newSpeed)")
        
        gameDelegate?.obstacleSpeed(speed: newSpeed)
    }
    
    func update(currentTime: TimeInterval) {
        
    }
    
    func tearDown() {
        timer.invalidate()
    }
}


