//
//  GameSceneController.swift
//  POCScenes
//
//  Created by Rebecca Mello on 07/03/22.
//

import GameplayKit
import SpriteKit


func randomizer(min: Int, max: Int) -> Int {
    let randomizer = GKRandomDistribution(lowestValue: min, highestValue: max)
    let randomIndex = randomizer.nextInt()
    return randomIndex
}

class GameSceneController: NSObject, SKPhysicsContactDelegate {
    var isGameStarted: Bool = false
    weak var gameDelegate: GameLogicDelegate?
    var timer = Timer()
    var timeCounter = 0
    var count: CGFloat = 10
    var fetcher = ObstacleFetcher()
    var shouldCreateObstacle: Bool = false
    private var currentPosition: Int = 3
    private var lastObstacleTimeCreated: TimeInterval = 3
    private var newSpeed: CGFloat = 1
    var delayIOS: TimeInterval = 2.8
    var delayTV: TimeInterval = 3.5
    private var minimumDelay: CGFloat = 1.1
    var initialPosition: CGFloat { 3 }
    var score: Int = 0
    private var timeScore: TimeInterval = 0
    private var timeSpeed: TimeInterval = 0
    var duration: CGFloat = 3
    var durationTV: CGFloat = 2
    var currentScore: Int?
    let defaults = UserDefaults.standard
    var pausedTime: TimeInterval = 0
    
    
    private func calculateScore(currentTime: TimeInterval) {
        if timeScore == 0 {
            timeScore = currentTime
        }
        let deltaTime = (currentTime - timeScore)
        if deltaTime >= 1 {
            score += 1
            gameDelegate?.drawScore(score: score)
            timeScore = currentTime
        }
    }
    
    func movePlayer(direction: Direction) -> CGFloat{
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
    
    func handlePause(isPaused: Bool) {
        if isPaused {
            pausedTime = Date().timeIntervalSince1970
        } else {
            let timeDifference = Date().timeIntervalSince1970 - pausedTime
            print(timeDifference, lastObstacleTimeCreated)
            lastObstacleTimeCreated += timeDifference
            print(lastObstacleTimeCreated)
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if contact.bodyB.node?.name == "Fly" || contact.bodyA.node?.name == "Fly" {
            gameDelegate?.collisionBetween(player: nodeA, enemy: nodeB)
        }
    }
    
    func audioVerification() {
        // Verifica se os áudios já estavam inativos
        if !AudioService.shared.getUserDefaultsStatus(with: .sound) {
            gameDelegate?.getSoundButton().updateImage(with: .soundOff)
        }
        
        if !AudioService.shared.getUserDefaultsStatus(with: .music) {
            gameDelegate?.getMusicButton().updateImage(with: .musicOff)
        }
    }
    
    func passedObstacles(node: SKNode) -> Bool {
            if let sprite = node as? SKSpriteNode {
                return sprite.position.x < (-1 * (sprite.size.width/2 + 20))
            } else {
                return false
            }
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
        calculateDelay(currentTime: currentTime)
        calculateScore(currentTime: currentTime)
        calculateDuration(currentTime: currentTime)
        currentScore = score
    }
    
    //MARK: Calculo de Duration
    private func calculateDuration(currentTime: TimeInterval) {
        if timeSpeed == 0 {
            timeSpeed = currentTime
        }
        let deltaTimeSpeed = (currentTime - timeSpeed)
        //print(duration)
        
        #if os(iOS)
        if deltaTimeSpeed >= 1 && duration > 0.8 {
            duration -= 0.04
            timeSpeed = currentTime
        }
        #elseif os(tvOS)
        if deltaTimeSpeed >= 0.8 && durationTV > 0.4 {
            durationTV -= 0.015
            timeSpeed = currentTime
        }
        #endif
    }
    
    //MARK: Calculo de Delay
    private func calculateDelay(currentTime: TimeInterval) {
        if lastObstacleTimeCreated == 0 {
            lastObstacleTimeCreated = currentTime
        }
        let pastTime = (currentTime - lastObstacleTimeCreated)
        
        #if os(iOS)
        if pastTime >= delayIOS {
            let obstacles = chooseObstacle()
            obstacles.forEach {
                gameDelegate?.createObstacle(obstacle: $0)
            }
            lastObstacleTimeCreated = currentTime
            
            if delayIOS > minimumDelay { // limite minimo do delay
                delayIOS -= 0.05 // cada vez que o update é chamado diminui o delay
            }
        }
        
        #elseif os (tvOS)
        print("delay tv \(delayTV)")
        if pastTime >= delayTV {
            let obstacles = chooseObstacle()
            obstacles.forEach {
                gameDelegate?.createObstacle(obstacle: $0)
            }
            lastObstacleTimeCreated = currentTime
            
            if delayTV > 1 { // limite minimo do delay
                delayTV -= 0.085 // cada vez que o update é chamado diminui o delay
            }
        }
        #endif
    }
    
    func gameStarted() {
        if isGameStarted {
            gameDelegate?.setPhysicsWorldDelegate()
        }
    }
    
    //MARK: Primera vez do player no jogo
    func firstTime() {
        defaults.set(false, forKey: "playerFirstTime")
    }
    
    //MARK: TearDown
    func tearDown() {
        timeCounter = 0
        timer.invalidate()
        defaults.set(score, forKey: "currentScore")
        score = 0
    }
}


