//
//  GameSceneController.swift
//  POCScenes
//
//  Created by Rebecca Mello on 07/03/22.
//

import SpriteKit

class GameSceneController: NSObject, SKPhysicsContactDelegate {
    weak var gameDelegate: GameLogicDelegate?
    
    var isGameStarted: Bool = false
    var fetcher = ObstacleFetcher()
    var currentPosition: Int = 3
    var lastObstacleTimeCreated: TimeInterval = 3
    var lastCoinTimeCreated: TimeInterval = 3
    
    var score: Int = 0
    var timeScore: TimeInterval = 0
    var timeSpeed: TimeInterval = 0
    var pausedTime: TimeInterval = 0
    
    var coinsCollected: Int = 0
    
    var delay: TimeInterval
    var coinDelay: TimeInterval
    var duration: CGFloat
    
    override init() {
        #if os(iOS)
        self.delay = 2.8
        self.coinDelay = 10
        self.duration = 3
        #elseif os (tvOS)
        self.delay = 3.5
        self.coinDelay = 7
        self.duration = 2
        #endif
        
        super.init()
    }
    
    private func calculateScore(currentTime: TimeInterval) {
        if timeScore == 0 {
            timeScore = currentTime
        }
        let deltaTime = (currentTime - timeScore)
        if deltaTime >= 1 {
            score += 1
            if score == 80 && coinsCollected == 0 {
                GameCenterService.shared.showAchievements(achievementID: "noCoinsInRunID")
            }
            
            gameDelegate?.drawScore(score: score)
            timeScore = currentTime
        }
    }
    
    func movePlayer(direction: Direction) -> CGFloat {
        switch direction {
        case .up:
            if currentPosition != 5 {
                AudioService.shared.soundManager(with: .swipe, soundAction: .play)
                currentPosition += 2
            }
        case .down:
            if currentPosition != 1 {
                AudioService.shared.soundManager(with: .swipe, soundAction: .play)
                currentPosition -= 2
            }
        }
        return CGFloat(currentPosition)
    }
    
    func handlePause(isPaused: Bool) {
        if isPaused {
            pausedTime = Date().timeIntervalSince1970
        } else {
            let timeDifference = Date().timeIntervalSince1970 - pausedTime
            lastObstacleTimeCreated += timeDifference
        }
    }
    
    func audioVerification() {
        // Verifica se os áudios já estavam inativos
        if !AudioService.shared.getUserDefaultsStatus(with: .sound) {
            gameDelegate?.getButtons()[3].updateImage(with: .soundOff)
        }
        
        if !AudioService.shared.getUserDefaultsStatus(with: .music) {
            gameDelegate?.getButtons()[4].updateImage(with: .musicOff)
        }
    }
    
    func passedObstacles(node: SKNode) -> Bool {
        if let sprite = node as? SKSpriteNode {
            sprite.physicsBody = nil
            return sprite.position.x < (-1 * (sprite.size.width/2 + 20))
        }
        return false
    }
    
    func createSwipeGesture(direction: UISwipeGestureRecognizer.Direction) -> UISwipeGestureRecognizer {
        let swipe = UISwipeGestureRecognizer(
            target: self, action: #selector(self.respondToSwipeGesture)
        )
        swipe.direction = direction
        return swipe
    }

    @objc func respondToSwipeGesture(gesture: UISwipeGestureRecognizer) {
        if let direction = gesture.direction.direction {
            if gameDelegate?.pausedStatus() == false {
                gameDelegate?.movePlayer(direction: direction)
            }
        }
    }
    
    func pauseTapGesture() -> UITapGestureRecognizer {
        let gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(self.tvOSAction))
        gesture.allowedPressTypes = [NSNumber(value: UIPress.PressType.playPause.rawValue)]
        return gesture
    }
    
    func buttonsTapGesture() -> UITapGestureRecognizer {
        let gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(self.clicked))
        return gesture
    }
        
    @objc func clicked() {
        if gameDelegate?.getButtons()[0].isFocused == true {
            gameDelegate?.resumeGame()
            
        } else if gameDelegate?.getButtons()[1].isFocused == true {
            gameDelegate?.goToHome()
            
        } else if gameDelegate?.getButtons()[2].isFocused == true {
            gameDelegate?.restartGame()
            
        } else if gameDelegate?.getButtons()[3].isFocused == true {
            gameDelegate?.soundAction()
            
        } else if gameDelegate?.getButtons()[4].isFocused == true {
            gameDelegate?.musicAction()
        }
    }

    // Função de clicar no botão com tvRemote
    @objc private func tvOSAction() {
        gameDelegate?.pauseGame()
    }
    
    func buttonActions() {
        gameDelegate?.getButtons()[0].action = {
            self.gameDelegate?.resumeGame()
        }
        
        gameDelegate?.getButtons()[1].action = {
            self.gameDelegate?.goToHome()
        }
        
        gameDelegate?.getButtons()[2].action = {
            self.gameDelegate?.restartGame()
        }
        
        gameDelegate?.getButtons()[3].action = {
            self.gameDelegate?.soundAction()
        }
        
        gameDelegate?.getButtons()[4].action = {
            self.gameDelegate?.musicAction()
        }
    }
    
    func moveBackground() {
        guard let gameDelegate = self.gameDelegate else {return}
        let scenario1 = gameDelegate.getScenario()[0]
        let scenario2 = gameDelegate.getScenario()[1]
        
        let value = 1.5 + CGFloat(score/15)
        scenario1.position.x -= value
        scenario2.position.x -= value
        
        self.updateTexture(scenario: scenario1, xValue: scenario2.position.x)
        self.updateTexture(scenario: scenario2, xValue: scenario1.position.x)
    }
    
    func updateTexture(scenario: SKSpriteNode, xValue: CGFloat) {
        let half = scenario.size.width/2
        if scenario.position.x <= -half {
            scenario.position.x = half + xValue*2
            
            if score >= 30 && score <= 50 || score >= 80 && score <= 100 {
                scenario.texture = SKTexture(imageNamed: "cenarioAzul")
            } else {
                scenario.texture = SKTexture(imageNamed: "cenario")
            }
        }
    }
    
    func chooseObstacle() -> [Obstacle] {
        let weight: Int = self.fetcher.randomizer(min: 1, max: 2)
        let quantity = chooseObstacleQuantity(for: weight)
        let lanes = chooseObstacleLane(for: weight, quantity: quantity)
        return lanes.map { fetcher.fetch(lane: $0) } // transforma a lista de lanes em lista de obstacles
    }
    
    private func chooseObstacleQuantity(for weight: Int) -> Int {
        if weight != 1 {
            return self.fetcher.randomizer(min: 1, max: 2)
        }
        return 1
    }
    
    private func chooseObstacleLane(for weight: Int, quantity: Int) -> [Int] {
        var lanes: [Int]
        if weight == 2 && quantity == 1 {
            lanes = [2, 4]
        } else {
            lanes = [1, 3, 5]
        }
        lanes.shuffle()
        // cria um array de tam das lanes e pega o primeiro ou primeiro e segundo
        return Array(0..<quantity).map { lanes[$0] }
    }
    
    func update(currentTime: TimeInterval) {
        calculateDelay(currentTime: currentTime)
        calculateCoinDelay(currentTime: currentTime)
        calculateScore(currentTime: currentTime)
        calculateDuration(currentTime: currentTime)
    }
    
    /// Calculo de Duration
    private func calculateDuration(currentTime: TimeInterval) {
        let deltaTimeSpeed = self.getPastTime(past: timeSpeed, actual: currentTime)
        
        #if os(iOS)
        if deltaTimeSpeed >= 1 && duration > 0.8 {
            duration -= 0.04
            timeSpeed = currentTime
        }
        #elseif os(tvOS)
        if deltaTimeSpeed >= 0.8 && duration > 0.4 {
            duration -= 0.015
            timeSpeed = currentTime
        }
        #endif
    }
    
    /// Cálculo de Delay
    private func calculateDelay(currentTime: TimeInterval) {
        let pastTime = self.getPastTime(past: lastObstacleTimeCreated, actual: currentTime)
        if pastTime >= self.delay {
            let obstacles = chooseObstacle()
            obstacles.forEach {
                gameDelegate?.createObstacle(obstacle: $0)
            }
            lastObstacleTimeCreated = currentTime
            
            #if os(iOS)
            if self.delay > 1.1 {
                self.delay -= 0.05
            }
            #elseif os (tvOS)
            if self.delay > 1 {
                self.delay -= 0.085
            }
            #endif
        }
    }
    
    private func calculateCoinDelay(currentTime: TimeInterval) {
        let pastTime = self.getPastTime(past: lastCoinTimeCreated, actual: currentTime)
        if pastTime >= self.coinDelay {
            gameDelegate?.createCoin()
            lastCoinTimeCreated = currentTime
            
            #if os(iOS)
            if self.coinDelay > 1.5 {
                self.coinDelay -= 0.05
            }
            #elseif os (tvOS)
            if self.coinDelay > 4 {
                self.coinDelay -= 0.085
            }
            #endif
        }
    }
    
    func getPastTime(past: TimeInterval, actual: TimeInterval) -> TimeInterval {
        var past = past
        if past.isZero {
            past = actual
        }
        return actual - past
    }
    
    func collisionHandler(with node: SKSpriteNode) {
        if node.name == "Coin" {
            AudioService.shared.soundManager(with: .coin, soundAction: .play)
            
            increaseCoinScore()
            node.removeFromParent()
            
            switch self.coinsCollected {
            case 5:
                GameCenterService.shared.showAchievements(achievementID: "firstCoinsInRunID")
            case 12:
                GameCenterService.shared.showAchievements(achievementID: "secondCoinsInRunID")
            default: break
            }
        
        } else {
            guard let nodeTexture = node.texture else {return}
            
            let grandmaTexture = SKTexture(imageNamed: "vovo")
            
            if nodeTexture.description == grandmaTexture.description {
                GameCenterService.shared.showAchievements(achievementID: "crashedGrandmaID")
            }
            
            gameDelegate?.goToGameOverScene()
        }
    }
    
    /// Faz a contagem da moeda e do score e cria a ação da label
    func increaseCoinScore() {
        self.coinsCollected += 1
        self.score += 2
        
        let wait = SKAction.wait(forDuration: 1)
        let hide = SKAction.run {
            self.gameDelegate?.setCoinScoreLabelVisibility(for: true)
        }
        
        let sequence = SKAction.sequence([wait, hide])
        
        self.gameDelegate?.runCoinScoreLabelAction(with: sequence)
        self.gameDelegate?.setCoinScoreLabelVisibility(for: false)
    }
}
