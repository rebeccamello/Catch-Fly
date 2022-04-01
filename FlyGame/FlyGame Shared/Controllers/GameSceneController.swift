//
//  GameSceneController.swift
//  POCScenes
//
//  Created by Rebecca Mello on 07/03/22.
//

import GameplayKit
import SpriteKit
import GameKit

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
    private var currentPosition: Int = 3
    private var lastObstacleTimeCreated: TimeInterval = 3
    private var lastCoinTimeCreated: TimeInterval = 3
    private var newSpeed: CGFloat = 1
    var delayIOS: TimeInterval = 2.8
    var delayTV: TimeInterval = 3.5
    var coinDelayIOS: TimeInterval = 10
    var coinDelayTV: TimeInterval = 7
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
    var buttonsPause = UITapGestureRecognizer()
    var buttonTvOS = UITapGestureRecognizer()
    let grandmaTexture = SKTexture(imageNamed: "vovo")
    var coinsInRun: Int = 0
    
    private func calculateScore(currentTime: TimeInterval) {
        if timeScore == 0 {
            timeScore = currentTime
        }
        let deltaTime = (currentTime - timeScore)
        if deltaTime >= 1 {
            score += 1
            if score == 80 && coinsInRun == 0 {
                GameCenterService.shared.showAchievements(achievementID: "noCoinsInRunID")
            }
            
            gameDelegate?.drawScore(score: score)
            timeScore = currentTime
        }
    }
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
        if gameDelegate?.pausedStatus() == false {
            gameDelegate?.movePlayer(direction: direction)
        }
    }
    
#if os(tvOS)
    func addTargetToTapGestureRecognizer() -> UITapGestureRecognizer {
        buttonsPause.addTarget(self, action: #selector(clicked))
        
        return buttonsPause
    }
    
    @objc func clicked() {
        if gameDelegate?.getResumeButton().isFocused == true {
            gameDelegate?.resumeGame()
            
        } else if gameDelegate?.getHomeButton().isFocused == true {
            gameDelegate?.goToHome()
            
        } else if gameDelegate?.getRestartButton().isFocused == true {
            gameDelegate?.restartGame()
            
        } else if gameDelegate?.getSoundButton().isFocused == true {
            gameDelegate?.soundAction()
            
        } else if gameDelegate?.getMusicButton().isFocused == true {
            gameDelegate?.musicAction()
        }
    }
#endif
    
    func calculateObstacleMovement(allObstacles: [SKNode]) {
        for obstacle in allObstacles {
            if gameDelegate?.pausedStatus() == true {
                obstacle.position.x -= 0
            }
            else {
#if os(iOS)
                let moveObstAction = SKAction.moveTo(x: (-100000), duration: duration*100)
#elseif os(tvOS)
                let moveObstAction = SKAction.moveTo(x: (-100000), duration: durationTV*100)
#endif
                
                obstacle.run(moveObstAction)
            }
        }
    }
    
#if os(tvOS)
    func addTargetToPauseActionToTV() -> UITapGestureRecognizer {
        self.buttonTvOS.addTarget(self, action: #selector(self.tvOSAction))
        self.buttonTvOS.allowedPressTypes = [NSNumber(value: UIPress.PressType.playPause.rawValue)]
        
        return buttonTvOS
    }
#endif
    
    // MARK: - Função de clicar no botão com tvRemote
    @objc private func tvOSAction() {
        gameDelegate?.pauseGame()
    }
    
    func buttonActions() {
        gameDelegate?.getRestartButton().action = {
            self.gameDelegate?.restartGame()
        }
        
        gameDelegate?.getHomeButton().action = {
            self.gameDelegate?.goToHome()
        }
        
        gameDelegate?.getResumeButton().action = {
            self.gameDelegate?.resumeGame()
        }
        
        gameDelegate?.getSoundButton().action = {
            self.gameDelegate?.soundAction()
        }
        
        gameDelegate?.getMusicButton().action = {
            self.gameDelegate?.musicAction()
        }
    }
    
    func moveBackground() {
        gameDelegate?.getScenario().position.x -= (1.5+(CGFloat(score/15)))
        gameDelegate?.getScenario2().position.x -= (1.5+(CGFloat(score/15)))
        
        guard let scenarioWidth = gameDelegate?.getScenario().size.width else {
            return
        }
        
        guard let scenarioXPosition = gameDelegate?.getScenario().position.x else {
            return
        }
        
        guard let scenario2XPosition = gameDelegate?.getScenario2().position.x else {
            return
        }
        
        guard let scenario2Width = gameDelegate?.getScenario2().size.width else {
            return
        }
        
        if scenarioXPosition <= -scenarioWidth/2 {
            gameDelegate?.getScenario().position.x = scenarioWidth/2 + scenario2XPosition*2
            
            if score >= 30 && score <= 50 || score >= 80 && score <= 100 {
                gameDelegate?.getScenario().texture = gameDelegate?.getScenarioTextures()[1]
            } else {
                gameDelegate?.getScenario().texture = gameDelegate?.getScenarioTextures()[0]
            }
        }
        
        if scenario2XPosition <= -scenario2Width/2 {
            gameDelegate?.getScenario2().position.x = scenario2Width/2 + scenarioXPosition*2
            
            if score >= 30 && score <= 50 || score >= 80 && score <= 100 {
                gameDelegate?.getScenario2().texture = gameDelegate?.getScenarioTextures()[1]
            } else {
                gameDelegate?.getScenario2().texture = gameDelegate?.getScenarioTextures()[0]
            }
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
        if weight == 1 {
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
        // cria um array de tam das lanes e pega o primeiro ou primeiro e segundo
        return Array(0..<quantity).map { lanes[$0] }
    }
    func update(currentTime: TimeInterval) {
        calculateDelay(currentTime: currentTime)
        calculateCoinDelay(currentTime: currentTime)
        calculateScore(currentTime: currentTime)
        calculateDuration(currentTime: currentTime)
        currentScore = score
    }
    // MARK: Calculo de Duration
    private func calculateDuration(currentTime: TimeInterval) {
        if timeSpeed == 0 {
            timeSpeed = currentTime
        }
        let deltaTimeSpeed = (currentTime - timeSpeed)
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
    // MARK: Calculo de Delay
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
    private func calculateCoinDelay(currentTime: TimeInterval) {
        if lastCoinTimeCreated == 0 {
            lastCoinTimeCreated = currentTime
        }
        let pastTime = (currentTime - lastCoinTimeCreated)
#if os(iOS)
        if pastTime >= coinDelayIOS {
            gameDelegate?.createCoin()
            lastCoinTimeCreated = currentTime
            if coinDelayIOS > 1.5 { // limite minimo do delay
                coinDelayIOS -= 0.05 // cada vez que o update é chamado diminui o delay
            }
        }
#elseif os (tvOS)
        if pastTime >= coinDelayTV {
            gameDelegate?.createCoin()
            lastCoinTimeCreated = currentTime
            if coinDelayTV > 4 { // limite minimo do delay
                coinDelayTV -= 0.085 // cada vez que o update é chamado diminui o delay
            }
        }
#endif
    }
    
    // MARK: TearDown
    func tearDown() {
        timeCounter = 0
        timer.invalidate()
        defaults.set(score, forKey: "currentScore")
        score = 0
    }
    
    func contact(contact: SKPhysicsContact, nodeA: SKSpriteNode, nodeB: SKSpriteNode) {
        if contact.bodyB.node?.name == "Fly" || contact.bodyA.node?.name == "Fly" {
            collisionBetween(player: nodeA, enemy: nodeB)
        }
    }
    
    func increaseScore(player: SKNode, enemy: SKNode) {
        score += 2
        let wait = SKAction.wait(forDuration: 1)
        let hide = SKAction.run {
            self.gameDelegate?.getPlusTwoLabel().isHidden = true
        }
        let sequence = SKAction.sequence([wait, hide])
        
        if player.name == "Coin" {
            player.removeFromParent()
            self.gameDelegate?.getPlusTwoLabel().isHidden = false
            self.gameDelegate?.getPlusTwoLabel().run(sequence)
            
        } else {
            enemy.removeFromParent()
            self.gameDelegate?.getPlusTwoLabel().isHidden = false
            self.gameDelegate?.getPlusTwoLabel().run(sequence)
        }
    }
    
    func collisionBetween(player: SKSpriteNode, enemy: SKSpriteNode) {
        if player.name == "Coin" || enemy.name == "Coin" {
            AudioService.shared.soundManager(with: .coin, soundAction: .play)
            increaseScore(player: player, enemy: enemy)
            coinsInRun += 1
            print(coinsInRun)
            if coinsInRun == 5 {
                GameCenterService.shared.showAchievements(achievementID: "firstCoinsInRunID")
            }
            if coinsInRun == 12 {
                GameCenterService.shared.showAchievements(achievementID: "secondCoinsInRunID")
            }
        } else {
            guard let playerTexture = player.texture else {return}
            guard let enemyTexture = enemy.texture else {return}
            
            if playerTexture.description == grandmaTexture.description || enemyTexture.description == grandmaTexture.description {
                GameCenterService.shared.showAchievements(achievementID: "crashedGrandmaID")
            }
            
            gameDelegate?.goToGameOverScene()
        }
    }
}
