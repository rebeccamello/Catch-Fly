//
//  GameScene.swift
//  FlyGame Shared
//
//  Created by Nathalia do Valle Papst on 07/03/22.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    private var currentTime: TimeInterval = 0
    var blueScenarioTexture = SKTexture(imageNamed: "cenarioAzul")
    var greenScenarioTexture = SKTexture(imageNamed: "cenario")
    var defaults = UserDefaults.standard
    
    lazy var scoreLabel: SKLabelNode = {
        var lbl = SKLabelNode()
        lbl.numberOfLines = 0
        lbl.fontColor = SKColor.black
        lbl.zPosition = 3
        lbl.fontName = "munro"
        lbl.text = "0"
        return lbl
    }()
    
    lazy var plusTwo: SKLabelNode = {
       var lbl = SKLabelNode()
        lbl.numberOfLines = 0
        lbl.fontColor = SKColor.black
        lbl.zPosition = 3
        lbl.fontName = "munro"
        lbl.text = "+2"
        return lbl
    }()
    
    lazy var pauseButton: SKButtonNode = {
        let but = SKButtonNode(image: .pause, action: {
            self.pauseGame()
        })
        but.zPosition = 3
        return but
    }()
    
    lazy var pauseMenu: PauseMenu = {
        var menu = PauseMenu()
        menu.gameDelegate = self
        return menu
    }()
    
    lazy var scenarioImage: SKSpriteNode = {
        var scenario = SKSpriteNode()
        scenario = SKSpriteNode(imageNamed: "cenario")
        scenario.zPosition = -1
        return scenario
    }()
    
    lazy var scenarioImage2: SKSpriteNode = {
        var scenario = SKSpriteNode()
        scenario = SKSpriteNode(imageNamed: "cenario")
        scenario.zPosition = -1
        return scenario
    }()
    
    lazy var gameLogic: GameSceneController = {
        let g = GameSceneController()
        g.gameDelegate = self
        return g
    }()
    
    lazy var playerNode: SKSpriteNode = {
        var bug = SKSpriteNode(imageNamed: "mosca")
        bug.zPosition = 1
        bug.name = "Fly"
        bug.texture?.filteringMode = .nearest
        let frames: [SKTexture] = createTexture("Mosca")
        bug.run(SKAction.repeatForever(SKAction.animate(with: frames,
                                                        timePerFrame: TimeInterval(0.05),
                                                        resize: false, restore: true)))
        return bug
    }()
    
    class func newGameScene() -> GameScene {
        let scene = GameScene()
        scene.scaleMode = .resizeFill
        return scene
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - setUpScenne
    func setUpScene() {
        removeAllChildren()
        removeAllActions()
        
        #if os(tvOS)
            addPauseActionGesture()
        #endif
        
        self.addChild(scenarioImage)
        self.addChild(scenarioImage2)
        self.addChild(playerNode)
        self.addChild(plusTwo)
        plusTwo.isHidden = true
        
        #if os(iOS)
            self.addChild(pauseButton)
        #endif
        
        self.addChild(pauseMenu)
        self.addChild(scoreLabel)
        
        setNodesSize()
        setNodesPosition()
        addSwipeGestures()
        gameLogic.buttonActions()
        setSwipeGesture()
        
        pauseMenu.isHidden = true
    }
    
    func setNodesSize() {
        playerNode.size = CGSize(width: self.size.height/5.2, height: self.size.height/5.2)
        scenarioImage.size = CGSize(width: self.size.width * 1.2, height: self.size.height)
        scenarioImage2.size = CGSize(width: self.size.width * 1.2, height: self.size.height)
        
        pauseButton.setScale(self.size.height*0.00035)
        tutorialNode.setScale(self.size.height*0.0035)
        
        scoreLabel.fontSize = self.size.height/15
        plusTwo.fontSize = self.size.height/15
    }
    
    func setNodesPosition() {
        playerNode.position = CGPoint(x: size.width/4, y: size.height/2)
        pauseMenu.position = CGPoint(x: size.width/2, y: size.height/2)
        pauseButton.position = CGPoint(x: size.width*0.06, y: size.height*0.88)
        tutorialNode.position = CGPoint(x: size.width/2, y: size.height * 0.6)
        
#if os(iOS)
        scoreLabel.position = CGPoint(x: pauseButton.position.x + scoreLabel.frame.size.width/2 + 50, y: pauseButton.position.y - scoreLabel.frame.size.height/2)
        plusTwo.position = CGPoint(x: scoreLabel.position.x + plusTwo.frame.size.width/2 + 20, y: pauseButton.position.y - scoreLabel.frame.size.height/2)

#elseif os(tvOS)
        scoreLabel.position = pauseButton.position
        plusTwo.position = CGPoint(x: scoreLabel.position.x + plusTwo.frame.size.width/2 + 50, y: scoreLabel.position.y)
#endif
        scenarioImage.position = CGPoint(x: scenarioImage.size.width/2, y: scenarioImage.size.height/2)
        scenarioImage2.position = CGPoint(x: scenarioImage2.size.width/2 + scenarioImage.position.x*2, y: scenarioImage2.size.height/2)
    }
    
    // MARK: - didMove
    override func didMove(to view: SKView) {
        self.setUpScene()
        
    #if os(tvOS)
        addTapGestureRecognizer()
    #endif

        gameLogic.gameStarted()
        gameLogic.audioVerification()
    }
    
    // MARK: didChangeSize
    override func didChangeSize(_ oldSize: CGSize) {
        self.setUpScene()
        
        setPhysics(node: playerNode)
    }
    
    // MARK: Update
    override func update(_ currentTime: TimeInterval) {
        self.currentTime = currentTime
        let outOfTheScreenNodes = children.filter { node in
            gameLogic.passedObstacles(node: node)
       }
        
        for node in outOfTheScreenNodes {
            node.physicsBody = nil
        }
        
        moveObstacle()
        gameLogic.moveBackground()
        removeChildren(in: outOfTheScreenNodes)
        gameLogic.update(currentTime: currentTime)
    }
    
    // MARK: Set Physics
    func setPhysics(node: SKSpriteNode) {
        node.physicsBody = SKPhysicsBody(texture: node.texture!, size: node.size)
        node.physicsBody?.affectedByGravity = false
        node.physicsBody?.isDynamic = true // faz reconhecer a colisao
        node.physicsBody?.allowsRotation = false
        node.physicsBody?.categoryBitMask = CollisionBitMask.flyCategory
        node.physicsBody?.collisionBitMask = CollisionBitMask.obstaclesCategory
        node.physicsBody?.contactTestBitMask = CollisionBitMask.coinCategory | CollisionBitMask.obstaclesCategory
    }
    
    func setPhysicsObstacles(node: SKSpriteNode) {
        node.physicsBody?.affectedByGravity = false
        node.physicsBody?.isDynamic = false // faz reconhecer a colisao
        node.physicsBody?.linearDamping = 0
        node.physicsBody?.friction = 0
        node.physicsBody?.categoryBitMask = CollisionBitMask.obstaclesCategory
        node.physicsBody?.collisionBitMask = CollisionBitMask.flyCategory
        node.physicsBody?.contactTestBitMask = CollisionBitMask.flyCategory
    }
    
    func setPhysicsCoins(node: SKSpriteNode) {
        node.physicsBody?.affectedByGravity = false
        node.physicsBody?.isDynamic = false // faz reconhecer a colisao
        node.physicsBody?.categoryBitMask = CollisionBitMask.coinCategory
        node.physicsBody?.collisionBitMask = 0
        node.physicsBody?.contactTestBitMask = CollisionBitMask.flyCategory
    }
    
    // MARK: Set Node Positions
    func setNodePosition() {
        playerNode.size.height = self.size.height/5.2
        playerNode.size.width = self.size.height/5.2
        playerNode.position = CGPoint(x: size.width/4, y: size.height/2)
        pauseMenu.position = CGPoint(x: size.width/2, y: size.height/2)
        pauseButton.position = CGPoint(x: size.width*0.06, y: size.height*0.88)
        pauseButton.setScale(self.size.height*0.00035)
        scoreLabel.fontSize = self.size.height/15
        plusTwo.fontSize = self.size.height/15
        
#if os(iOS)
        scoreLabel.position = CGPoint(x: pauseButton.position.x + scoreLabel.frame.size.width/2 + 50, y: pauseButton.position.y - scoreLabel.frame.size.height/2)
        plusTwo.position = CGPoint(x: scoreLabel.position.x + plusTwo.frame.size.width/2 + 20, y: pauseButton.position.y - scoreLabel.frame.size.height/2)
#elseif os(tvOS)
        scoreLabel.position = pauseButton.position
        plusTwo.position = CGPoint(x: scoreLabel.position.x + plusTwo.frame.size.width/2 + 50, y: scoreLabel.position.y)
#endif
    }
    
    // MARK: Create Texture
    func createTexture(_ name: String) -> [SKTexture] {
        let textureAtlas = SKTextureAtlas(named: name)
        var frames = [SKTexture]()
        for i in 1...textureAtlas.textureNames.count - 1 {
            frames.append(textureAtlas.textureNamed(textureAtlas.textureNames[i]))
        }
        return frames
    }
    
    func addSwipeGestures() {
        self.view?.addGestureRecognizer(gameLogic.setSwipeGesture()[0])
        self.view?.addGestureRecognizer(gameLogic.setSwipeGesture()[1])
    }
    
// MARK: - Funcao ao sair do App e voltar
        
    public override func sceneDidLoad() {
        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActiveNotification(notification:)), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didEnterBackgroundNotification(notification:)), name: UIApplication.willResignActiveNotification, object: nil)
    }

    @objc func didBecomeActiveNotification(notification: NSNotification) {
        self.isPaused = true
    }
    
    @objc func didEnterBackgroundNotification(notification: NSNotification) {
        pauseGame()
    }
    
    func collisionBetween(player: SKNode, enemy: SKNode) {
        if player.name == "Coin" || enemy.name == "Coin" {
            increaseScore(player: player, enemy: enemy)
        } else {
            goToGameOverScene()
        }
    }
    
    // MARK: Funçoes de quando há colisão
    func increaseScore(player: SKNode, enemy: SKNode) {
        gameLogic.score += 2
        let wait = SKAction.wait(forDuration: 1)
        let hide = SKAction.run {
            self.plusTwo.isHidden = true
        }
        let sequence = SKAction.sequence([wait, hide])
        
        if player.name == "Coin" {
            player.removeFromParent()
            plusTwo.isHidden = false
            plusTwo.run(sequence)

        } else {
            enemy.removeFromParent()
            plusTwo.isHidden = false
            plusTwo.run(sequence)
        }
    }
    
    func goToGameOverScene() {
        gameLogic.tearDown()
        self.isGameStarted = false
        let scene = GameOverScene.newGameScene()
        scene.score = gameLogic.score
        AudioService.shared.soundManager(with: .colision, soundAction: .play)
        view?.presentScene(scene)
        
#if os(tvOS)
        scene.run(SKAction.wait(forDuration: 0.02)) {
            scene.view?.window?.rootViewController?.setNeedsFocusUpdate()
            scene.view?.window?.rootViewController?.updateFocusIfNeeded()
        }
#endif
    }
    
    #if os(tvOS)
        func addTapGestureRecognizer() {
            self.view?.addGestureRecognizer(gameLogic.addTargetToTapGestureRecognizer())
        }
    #endif
    
        defaults.set(true, forKey: "playerFirstTime")
    }
    
    // MARK: - Criação e movimentação de obstáculos
    func createObstacle(obstacle: Obstacle) {
        let enemy = SKSpriteNode(imageNamed: obstacle.assetName)
        enemy.physicsBody = obstacle.physicsBody.copy() as? SKPhysicsBody
        enemy.zPosition = 2
        enemy.name = "Enemy"
        enemy.size.height = self.size.height/3 * CGFloat(obstacle.weight)
        enemy.size.width = self.size.height/3 * CGFloat(obstacle.width)
        setPhysicsObstacles(node: enemy)
        enemy.position = CGPoint(x: size.width + enemy.size.width, y: size.height * CGFloat(obstacle.lanePosition) / 6)
        addChild(enemy)
        moveObstacle()
    }
    
    func moveObstacle() {
        let allObstacles = children.filter { node in node.name == "Enemy" || node.name == "Coin" }
        for obstacle in allObstacles {
            if isPaused == true {
                obstacle.position.x -= 0
            }
            else {
#if os(iOS)
                let moveObstAction = SKAction.moveTo(x: (-100000), duration: gameLogic.duration*100)
#elseif os(tvOS)
                let moveObstAction = SKAction.moveTo(x: (-100000), duration: gameLogic.durationTV*100)
#endif
                obstacle.run(moveObstAction)
            }
        }
    }
    
    // MARK: Criação das moedas
    func createCoin() {
        var coinPosition: [CGFloat] = [1, 3, 5]
        coinPosition.shuffle()
        
        let coin = SKSpriteNode(imageNamed: "moeda0")
        coin.zPosition = 1
        coin.name = "Coin"
        coin.size.height = self.size.height/7
        coin.size.width = self.size.height/7
        coin.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "lustre"), size: CGSize(width: self.size.height/3, height: self.size.height/3)).copy() as? SKPhysicsBody
        coin.position = CGPoint(x: size.width + coin.size.width, y: size.height * coinPosition[0] / 6)
        setPhysicsCoins(node: coin)
        
        let frames: [SKTexture] = createTexture("Moedas")
        coin.run(SKAction.repeatForever(SKAction.animate(with: frames,
                                                         timePerFrame: TimeInterval(0.1),
                                                         resize: false, restore: true)))
        addChild(coin)
    }
    
    // MARK: Movimento da mosca
    func movePlayer(direction: Direction) {
        let position = gameLogic.movePlayer(direction: direction)
        let moveAction = SKAction.moveTo(y: position * (size.height / 6), duration: 0.05)
        moveAction.timingMode = .easeOut
        playerNode.run(moveAction)
        AudioService.shared.soundManager(with: .swipe, soundAction: .play)
    }
    
    #if os(tvOS)
        func addPauseActionGesture() {
            self.view?.addGestureRecognizer(gameLogic.addTargetToPauseActionToTV())
        }
    #endif
}

extension GameScene: GameLogicDelegate {
    func getSoundButton() -> SKButtonNode {
        return pauseMenu.soundButton
    }
    
    func getMusicButton() -> SKButtonNode {
        return pauseMenu.musicButton
    }
    
    func drawScore(score: Int) {
        scoreLabel.text = String(score)
    }
    
    func resumeGame() {
        self.isPaused = false
        self.gameLogic.handlePause(isPaused: isPaused)
        pauseMenu.isHidden = true
        pauseButton.isHidden = false
    }
    
    func pauseGame() {
        self.pauseMenu.isHidden = false
        self.isPaused = true
        self.gameLogic.handlePause(isPaused: self.isPaused)
    }
    
    func goToHome() {
        let scene = MenuScene.newGameScene()
        view?.presentScene(scene)
    }
    
    func musicAction() {
        AudioService.shared.toggleMusic(with: self.pauseMenu.musicButton)
    }
    
    func soundAction() {
        AudioService.shared.toggleSound(with: self.pauseMenu.soundButton)
    }
    
    func setPhysicsWorldDelegate() {
        physicsWorld.contactDelegate = gameLogic
    }
    
    func collisionBetween(player: SKNode, enemy: SKNode) {
        gameLogic.tearDown()
        gameLogic.isGameStarted = false
        let scene = GameOverScene.newGameScene()
        scene.score = gameLogic.score
        AudioService.shared.soundManager(with: .colision, soundAction: .play)
        view?.presentScene(scene)
        
        #if os(tvOS)
            scene.run(SKAction.wait(forDuration: 0.02)) {
            scene.view?.window?.rootViewController?.setNeedsFocusUpdate()
            scene.view?.window?.rootViewController?.updateFocusIfNeeded()
        }
        #endif
    }
    
    func movePlayer(direction: Direction) {
        let position = gameLogic.movePlayer(direction: direction)
        let moveAction = SKAction.moveTo(y: position * (size.height / 6), duration: 0.1)
        moveAction.timingMode = .easeOut
        playerNode.run(moveAction)
        AudioService.shared.soundManager(with: .swipe, soundAction: .play)
    }
    
    func pausedStatus() -> Bool {
        return isPaused
    }
    
    func getResumeButton() -> SKButtonNode {
        return pauseMenu.resumeButton
    }
    
    func getHomeButton() -> SKButtonNode {
        return pauseMenu.homeButton
    }
    
    func getRestartButton() -> SKButtonNode {
        return pauseMenu.retryButton
    }
    
    func restartGame() {
        let scene = GameScene.newGameScene()
        scene.gameLogic.isGameStarted = true
        self.view?.presentScene(scene)
    }
    
    func getScenario() -> SKSpriteNode {
        return scenarioImage
    }
    
    func getScenario2() -> SKSpriteNode {
        return scenarioImage2
    }
    
    func getScenarioTextures() -> [SKTexture] {
        return [greenScenarioTexture, blueScenarioTexture]
    }
}

#if os(tvOS)
    extension GameScene {
        override var preferredFocusEnvironments: [UIFocusEnvironment] {
            return [pauseMenu.resumeButton]
        }
    }
#endif
