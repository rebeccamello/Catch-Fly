//
//  GameScene.swift
//  FlyGame Shared
//
//  Created by Nathalia do Valle Papst on 07/03/22.
//

import SpriteKit

class GameScene: SKScene {
    private var timeWhenPaused = Date()
    
    private var allObstacles: [SKNode] = []
    
    lazy var scoreLabel: SKLabelNode = {
        var lbl = SKLabelNode()
        lbl.numberOfLines = 0
        lbl.fontColor = SKColor.black
        lbl.fontName = "munro"
        lbl.text = "0"
        return lbl
    }()
    
    lazy var plusTwo: SKLabelNode = {
       var lbl = SKLabelNode()
        lbl.numberOfLines = 0
        lbl.fontColor = SKColor.black
        lbl.fontName = "munro"
        lbl.text = "+2"
        return lbl
    }()
    
    lazy var pauseButton = SKButtonNode(image: .pause) {
        self.pauseGame()
    }
        
    lazy var pauseMenu: PauseMenu = {
        var menu = PauseMenu()
        menu.gameDelegate = self
        return menu
    }()
    
    lazy var scenarioImage = SKSpriteNode(imageNamed: "cenario")
    
    lazy var scenarioImage2 = SKSpriteNode(imageNamed: "cenario")
    
    lazy var gameLogic: GameSceneController = {
        let g = GameSceneController()
        g.gameDelegate = self
        return g
    }()
    
    lazy var playerNode: SKSpriteNode = {
        var player = SKSpriteNode(imageNamed: "mosca")
        player.texture?.filteringMode = .nearest
        player.name = "Fly"
        
        player.run(SKAction.creatAnimation(by: "Mosca", time: 0.05))
        return player
    }()
    
    private let physicsContactDelegate = PhysicsContactDelegate()
    
    class func newGameScene() -> GameScene {
        let scene = GameScene()
        scene.scaleMode = .resizeFill
        return scene
    }
    
    #if os(tvOS)
    override var preferredFocusEnvironments: [UIFocusEnvironment] {
        return [pauseMenu.resumeButton]
    }
    #endif
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
        
    // MARK: - Ciclo de Vida
    
    override func didMove(to view: SKView) {
        self.setUpScene()
        
        self.addSwipeGestureRecognizer()
        
        #if os(tvOS)
        addTapGestureRecognizer()
        #endif
        
        gameLogic.buttonActions()
        gameLogic.audioVerification()
        
        self.physicsContactDelegate.gameSceneDelegate = self
        self.physicsWorld.contactDelegate = self.physicsContactDelegate
        
    }
    
    override func didChangeSize(_ oldSize: CGSize) {
        setNodesSize()
        setNodesPosition()
        
        self.playerNode.setupPhysics()
    }
    
    override func sceneDidLoad() {
        NotificationCenter.default.addObserver(
            self, selector: #selector(self.didLeaveFromBackgound),
            name: UIApplication.didBecomeActiveNotification, object: nil
        )
        
        NotificationCenter.default.addObserver(
            self, selector: #selector(self.didEnterOnBackground),
            name: UIApplication.willResignActiveNotification, object: nil
        )
    }
    
    override func update(_ currentTime: TimeInterval) {
        self.moveObstacle()
        gameLogic.moveBackground()
        gameLogic.update(currentTime: currentTime)
    }
    
    /* MARK: - Settings */
    
    func setUpScene() {
        self.addChild(scenarioImage)
        self.addChild(scenarioImage2)
        self.addChild(playerNode)
        self.addChild(plusTwo)
        self.addChild(pauseMenu)
        self.addChild(scoreLabel)
        
        #if os(iOS)
        self.addChild(pauseButton)
        #endif
                
        plusTwo.isHidden = true
        pauseMenu.isHidden = true
    }
    
    func setNodesSize() {
        playerNode.size = CGSize(width: self.size.height/5.2, height: self.size.height/5.2)
        scenarioImage.size = CGSize(width: self.size.width * 1.2, height: self.size.height)
        scenarioImage2.size = scenarioImage.size
        
        pauseButton.setScale(self.size.height*0.00035)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            pauseButton.setScale(self.size.height*0.000225)
        }
        scoreLabel.fontSize = self.size.height/15
        plusTwo.fontSize = self.size.height/15
    }
    
    func setNodesPosition() {
        scenarioImage.setPositions(
            x: scenarioImage.size.width/2,
            y: scenarioImage.size.height/2,
            z: -1
        )
        
        scenarioImage2.setPositions(
            x: scenarioImage.position.x + scenarioImage.position.x*2,
            y: scenarioImage.position.y,
            z: -1
        )
        
        pauseMenu.setPositions(x: self.size.width/2, y: self.size.height/2, z: 4)
        pauseButton.setPositions(x: self.size.width*0.06, y: self.size.height*0.88, z: 3)
        
        playerNode.setPositions(x: self.size.width/4, y: self.size.height/2, z: 1)
        
        #if os(iOS)
        var gapScoreX: CGFloat = 50
        var gapPlusTwoX: CGFloat = 20
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            pauseButton.setPositions(x: self.size.width*0.045, y: self.size.height*0.9, z: 3)
            
            gapScoreX = 60
            gapPlusTwoX = 25
        }
                
        scoreLabel.setPositions(
            x: pauseButton.position.x + scoreLabel.frame.size.width/2 + gapScoreX,
            y: pauseButton.position.y - scoreLabel.frame.size.height/2, z: 3
        )
        
        plusTwo.setPositions(
            x: scoreLabel.position.x + plusTwo.frame.size.width/2 + gapPlusTwoX,
            y: pauseButton.position.y - scoreLabel.frame.size.height/2, z: 3
        )
        
        #elseif os(tvOS)
        scoreLabel.setPositions(x: self.size.width*0.06, y: self.size.height*0.88, z: 3)
        plusTwo.setPositions(
            x: scoreLabel.position.x + plusTwo.frame.size.width/2 + 50,
            y: scoreLabel.position.y, z: 3
        )
        #endif
    }
    
    // MARK: - App em segundo plano
    
    /// Quando entra no app (sai do segundo plano)
    @objc func didLeaveFromBackgound() {
        let dateNow = Date()
        let diference = Calendar.current.dateComponents([.second], from: self.timeWhenPaused, to: dateNow)
        
        if let seconds = diference.second {
            if seconds > 20 {
                self.goToHome()
                return
            }
        }
        self.isPaused = true
    }
    
    /// Quando sai do app (entra em segundo plano)
    @objc func didEnterOnBackground() {
        self.timeWhenPaused = Date()
        pauseGame()
    }
        
    func addTapGestureRecognizer() {
        // Reconhece o botão do controle para pausar
        self.view?.addGestureRecognizer(gameLogic.pauseTapGesture())
        
        // Ativa as funções dos botões quando selecionados
        self.view?.addGestureRecognizer(gameLogic.getTvControlTapRecognizer())
    }
    
    /// Reconhecimento dos swipes do controle
    func addSwipeGestureRecognizer() {
        self.view?.addGestureRecognizer(gameLogic.createSwipeGesture(direction: .up))
        self.view?.addGestureRecognizer(gameLogic.createSwipeGesture(direction: .down))
    }

    // MARK: - Criação e movimentação de obstáculos
    
    func moveObstacle() {
        if self.isPaused {
            for obstacle in self.allObstacles {
                obstacle.position.x -= 0
            }
        } else {
            let duration = gameLogic.duration*100
            
            for obstacle in self.allObstacles {
                obstacle.run(SKAction.moveTo(x: (-100000), duration: duration))
            }
        }
    }
    
    /// Cria uma moeda pronta pra ser usada
    func createCoin() {
        let coin = SKSpriteNode(imageNamed: "moeda0")
        coin.name = "Coin"
        
        // Física
        var size: CGFloat = self.size.height/3
        coin.physicsBody = SKPhysicsBody(
            texture: coin.texture!,
            size: CGSize(width: size, height: size)
        ).copy() as? SKPhysicsBody
        coin.setupPhysics()
        
        // Tamanho e posição
        size = self.size.height/7
        coin.size = CGSize(width: size, height: size)
        
        var coinPosition: [CGFloat] = [1, 3, 5]
        coinPosition.shuffle()
        coin.setPositions(x: self.size.width + size, y: self.size.height * coinPosition[0]/6, z: 1)
        
        // Animação
        coin.run(SKAction.creatAnimation(by: "Moedas", time: 0.1))
        
        self.addNode(with: coin)
    }
    
    func addNode(with node: SKNode) {
        // Add novo node na tela
        self.addChild(node)
        self.allObstacles = children.filter {node in node.name == "Enemy" || node.name == "Coin"}
        
        // Remove aqueles que não estão mais na tela
        removeChildren(in: children.filter {node in gameLogic.passedObstacles(node: node)})
    }
}

extension GameScene: GameLogicDelegate {
    func contact(with contact: SKPhysicsContact) {
        if contact.bodyA.node?.name == "Fly"{
            if let node = contact.bodyA.node as? SKSpriteNode {
                self.gameLogic.collisionHandler(with: node)
            }
            
        } else if contact.bodyB.node?.name == "Fly" {
            if let node = contact.bodyB.node as? SKSpriteNode {
                self.gameLogic.collisionHandler(with: node)
            }
        }
    }
    
    func createObstacle(obstacle: Obstacle) {
        let enemy = SKSpriteNode(imageNamed: obstacle.assetName)
        enemy.name = "Enemy"
        
        let sizeHeight: CGFloat = self.size.height/3
        enemy.size.height = sizeHeight * CGFloat(obstacle.weight)
        enemy.size.width = sizeHeight * CGFloat(obstacle.width)
        
        enemy.physicsBody = obstacle.physicsBody.copy() as? SKPhysicsBody
        enemy.setupPhysics()
        
        enemy.setPositions(
            x: self.size.width + enemy.size.width,
            y: self.size.height * CGFloat(obstacle.lanePosition) / 6,
            z: 2
        )
        
        self.addNode(with: enemy)
    }
    
    func setCoinScoreLabelVisibility(for status: Bool) {
        self.plusTwo.isHidden = status
    }
    
    func runCoinScoreLabelAction(with action: SKAction) {
        self.plusTwo.run(action)
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
    
    @objc func pauseGame() {
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
    
    func goToGameOverScene() {
        UserDefaults.updateValue(in: .gameScore, with: gameLogic.score)
        
        let scene = GameOverScene.newGameScene()
        scene.score = gameLogic.score
        
        self.view?.presentScene(scene)
        
        #if os(tvOS)
        scene.run(SKAction.wait(forDuration: 0.02)) {
            scene.view?.window?.rootViewController?.setNeedsFocusUpdate()
            scene.view?.window?.rootViewController?.updateFocusIfNeeded()
        }
        #endif
    }
    
    func movePlayer(direction: Direction) {
        let position = gameLogic.movePlayer(direction: direction)
        let moveAction = SKAction.moveTo(y: position * (size.height / 6), duration: 0.05)
        moveAction.timingMode = .easeOut
        playerNode.run(moveAction)
    }
    
    func pausedStatus() -> Bool {
        return isPaused
    }
    
    func getButtons() -> [SKButtonNode] {
        return [pauseMenu.resumeButton, pauseMenu.homeButton, pauseMenu.retryButton, pauseMenu.soundButton, pauseMenu.musicButton]
    }
    
    func restartGame() {
        let scene = GameScene.newGameScene()
        scene.gameLogic.isGameStarted = true
        self.view?.presentScene(scene)
    }
    
    func getScenario() -> [SKSpriteNode] {
        return [scenarioImage, scenarioImage2]
    }
}
