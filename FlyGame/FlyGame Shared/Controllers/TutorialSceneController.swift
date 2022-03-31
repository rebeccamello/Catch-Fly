//
//  TutorialSceneController.swift
//  FlyGame
//
//  Created by Caroline Taus on 24/03/22.
//

import Foundation
import SpriteKit

class TutorialSceneController {
    var currentPosition: Int = 3
    weak var tutorialDelegate: TutorialDelegate?
    var state = 0
    var obstacleIndex: Int = -1
    var obstacles: [Obstacle] = []
    var defaults = UserDefaults.standard
    
    func movePlayer(direction: Direction) -> CGFloat {
        var newPosition = currentPosition
        if direction == .up {
            if currentPosition != 5 {
                newPosition += 2
            }
        } else {
            if currentPosition != 1 {
                newPosition -= 2
            }
        }
        currentPosition = newPosition
        return CGFloat(newPosition)
    }
    
    func setSwipeGesture() -> [UISwipeGestureRecognizer] {
        let swipeUp: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeUp.direction = .up
        
        let swipeDown: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeDown.direction = .down
        
        return [swipeUp, swipeDown]
        
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        guard
            let swipeGesture = gesture as? UISwipeGestureRecognizer,
            let direction = swipeGesture.direction.direction
        else { return }
        
        tutorialDelegate?.movePlayer(direction: direction)
        shouldMoveObstacle()
        defaults.set(true, forKey: "playerFirstTime")
    }
    
    // swiftlint:disable cyclomatic_complexity
    // swiftlint:disable function_body_length
    // MARK: Should move obstacle
    func shouldMoveObstacle() {
        if obstacleIndex == -1 { // piano entra
            obstacleIndex += 1
            tutorialDelegate?.createObstacle(obstacle: obstacles[0])
            tutorialDelegate?.moveObstacle()
            state += 1
        }
        else if obstacleIndex == 0 && currentPosition == 5 && state == 1 { // piano sai
            tutorialDelegate?.moveObstacleOffScreen()
            state += 1
            tutorialDelegate?.getNodes()[0].isHidden = true
        }
        else if obstacleIndex == 1 && state == 2 { // entra lustre
            if let node = tutorialDelegate?.getNodes()[1] {
                tutorialDelegate?.addNode(node: node)
                tutorialDelegate?.createObstacle(obstacle: obstacles[1])
                tutorialDelegate?.moveObstacle()
                state += 1
            } else {
                return
            }
        }
        else if obstacleIndex == 1 && (currentPosition == 3 || currentPosition == 1) && state == 3 { // sair lustre
            tutorialDelegate?.getNodes()[1].isHidden = true
            tutorialDelegate?.moveObstacleOffScreen()
            state += 1
        }
        else if obstacleIndex == 2 && state == 4 { // entra xicara
            tutorialDelegate?.getNodes()[1].isHidden = false
            tutorialDelegate?.createObstacle(obstacle: obstacles[2])
            tutorialDelegate?.moveObstacle()
            state += 1
        }
        else if obstacleIndex == 2 && currentPosition == 1 && state == 5 { // sai xicara
            tutorialDelegate?.getNodes()[1].isHidden = true
            tutorialDelegate?.moveObstacleOffScreen()
            state += 1
        }
        else if state == 6 {
            if let label = tutorialDelegate?.getLabelNode() {
                tutorialDelegate?.addLabelNode(label: label)
                state += 1
                shouldMoveObstacle()
            } else {
                return
            }
        }
        else if state == 7 {
            if let size = tutorialDelegate?.getScreenSize() {
                let flyFly = SKAction.moveTo(x: size.width + 500, duration: 3)
                tutorialDelegate?.getNodes()[2].run(flyFly)
            } else {
                return
            }
        }
        else if state == 8 {
            let scene = GameScene.newGameScene()
            scene.gameLogic.isGameStarted = true
            tutorialDelegate?.presentScene(scene: scene)
        }
    }
    // swiftlint:enable cyclomatic_complexity
    // swiftlint:enable function_body_length
    
    func passedObstacles(node: SKNode) -> Bool {
            if let sprite = node as? SKSpriteNode {
                return sprite.position.x < (-1 * (sprite.size.width/2 + 20))
            } else {
                return false
            }
    }
}
