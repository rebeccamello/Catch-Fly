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
    var delay: TimeInterval
    var coinDelay: TimeInterval
    private var minimumDelay: CGFloat = 1.1
    var initialPosition: CGFloat { 3 }
    var score: Int = 0
    private var timeScore: TimeInterval = 0
    private var timeSpeed: TimeInterval = 0
    var duration: CGFloat
    var currentScore: Int?
    let defaults = UserDefaults.standard
    var pausedTime: TimeInterval = 0
    var buttonsPause = UITapGestureRecognizer()
    var buttonTvOS = UITapGestureRecognizer()
    let grandmaTexture = SKTexture(imageNamed: "vovo")
    var coinsInRun: Int = 0
    
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
            if score == 80 && coinsInRun == 0 {
                GameCenterService.shared.showAchievements(achievementID: "noCoinsInRunID")
            }
            
            gameDelegate?.drawScore(score: score)
            timeScore = currentTime
            
            gameDelegate?.removeNodesOutScreen()
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
            return sprite.position.x < (-1 * (sprite.size.width/2 + 20))
        }
        return false
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
    
#endif
    
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

            scenario.texture = SKTexture(imageNamed: "cenario")
            if score >= 30 && score <= 50 || score >= 80 && score <= 100 {
                scenario.texture = SKTexture(imageNamed: "cenarioAzul")
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
        if deltaTimeSpeed >= 0.8 && duration > 0.4 {
            duration -= 0.015
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
        if pastTime >= delay {
            let obstacles = chooseObstacle()
            obstacles.forEach {
                gameDelegate?.createObstacle(obstacle: $0)
            }
            lastObstacleTimeCreated = currentTime
            if delay > minimumDelay { // limite minimo do delay
                delay -= 0.05 // cada vez que o update é chamado diminui o delay
            }
        }
#elseif os (tvOS)
        if pastTime >= delay {
            let obstacles = chooseObstacle()
            obstacles.forEach {
                gameDelegate?.createObstacle(obstacle: $0)
            }
            lastObstacleTimeCreated = currentTime
            if delay > 1 { // limite minimo do delay
                delay -= 0.085 // cada vez que o update é chamado diminui o delay
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
        if pastTime >= coinDelay {
            gameDelegate?.createCoin()
            lastCoinTimeCreated = currentTime
            if coinDelay > 1.5 { // limite minimo do delay
                coinDelay -= 0.05 // cada vez que o update é chamado diminui o delay
            }
        }
#elseif os (tvOS)
        if pastTime >= coinDelay {
            gameDelegate?.createCoin()
            lastCoinTimeCreated = currentTime
            if coinDelay > 4 { // limite minimo do delay
                coinDelay -= 0.085 // cada vez que o update é chamado diminui o delay
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
