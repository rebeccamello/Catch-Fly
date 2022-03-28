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
    var hideTutorial: Bool = false
    
    lazy var scoreLabel: SKLabelNode = {
        var lbl = SKLabelNode()
        lbl.numberOfLines = 0
        lbl.fontColor = SKColor.black
        lbl.zPosition = 3
        lbl.fontName = "munro"
        lbl.text = "0"
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
        let frames:[SKTexture] = createTexture("Mosca")
        bug.run(SKAction.repeatForever(SKAction.animate(with: frames,
                                                        timePerFrame: TimeInterval(0.05),
                                                        resize: false, restore: true)))
        return bug
    }()
    
    lazy var tutorialNode: SKSpriteNode = {
        var hand = SKSpriteNode(imageNamed: "tut1")
        hand.zPosition = 1
        hand.texture?.filteringMode = .nearest
        let frames:[SKTexture] = createTexture("Tutorial")
        hand.run(SKAction.repeatForever(SKAction.animate(with: frames,
                                                        timePerFrame: TimeInterval(0.2),
                                                        resize: false, restore: true)))
        return hand
    }()
    
    class func newGameScene() -> GameScene {
        let scene = GameScene()
        scene.scaleMode = .resizeFill
        return scene
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: - setUpScene
    
    func setUpScene() {
        removeAllChildren()
        removeAllActions()
        
        hideTutorial = defaults.bool(forKey: "playerFirstTime")
        
        #if os(tvOS)
            addPauseActionGesture()
        #endif
        
        self.addChild(scenarioImage)
        self.addChild(scenarioImage2)
        self.addChild(playerNode)
        
        #if os(iOS)
            self.addChild(pauseButton)
        #endif
        
        self.addChild(pauseMenu)
        self.addChild(scoreLabel)
        
        if !hideTutorial {
            self.addChild(tutorialNode)
        }
        
        setNodesSize()
        setNodesPosition()
        addSwipeGestures()
        gameLogic.buttonActions()
        
        pauseMenu.isHidden = true
    }
    
    func setNodesSize() {
        playerNode.size = CGSize(width: self.size.height/5.2, height: self.size.height/5.2)
        scenarioImage.size = CGSize(width: self.size.width * 1.2, height: self.size.height)
        scenarioImage2.size = CGSize(width: self.size.width * 1.2, height: self.size.height)
        
        pauseButton.setScale(self.size.height*0.00035)
        tutorialNode.setScale(self.size.height*0.0035)
        
        scoreLabel.fontSize = self.size.height/15
    }
    
    func setNodesPosition() {
        playerNode.position = CGPoint(x: size.width/4, y: size.height/2)
        pauseMenu.position = CGPoint(x: size.width/2, y: size.height/2)
        pauseButton.position = CGPoint(x: size.width*0.06, y: size.height*0.88)
        tutorialNode.position = CGPoint(x: size.width/2, y: size.height * 0.6)
        
#if os(iOS)
        scoreLabel.position = CGPoint(x: pauseButton.position.x + scoreLabel.frame.size.width/2 + 50, y: pauseButton.position.y - scoreLabel.frame.size.height/2)
#elseif os(tvOS)
        scoreLabel.position = pauseButton.position
#endif
        scenarioImage.position = CGPoint(x: scenarioImage.size.width/2, y: scenarioImage.size.height/2)
        scenarioImage2.position = CGPoint(x: scenarioImage2.size.width/2 + scenarioImage.position.x*2, y: scenarioImage2.size.height/2)
    }
    
    //MARK: - didMove
    override func didMove(to view: SKView) {
        self.setUpScene()
        
    #if os(tvOS)
        addTapGestureRecognizer()
    #endif

        gameLogic.gameStarted()
        gameLogic.audioVerification()
    }
    
    //MARK: didChangeSize
    override func didChangeSize(_ oldSize: CGSize) {
        self.setUpScene()
        
        setPhysics(node: playerNode)
    }
    
    //MARK: Update
    override func update(_ currentTime: TimeInterval) {
        self.currentTime = currentTime
        let outOfTheScreenNodes = children.filter { node in
            gameLogic.passedObstacles(node: node)
       }
        
        for node in outOfTheScreenNodes {
            node.physicsBody = nil
        }
        
        moveObstacle()
        moveBackground()
        removeChildren(in: outOfTheScreenNodes)
        gameLogic.update(currentTime: currentTime)
    }
    
    //MARK: Set Physics
    func setPhysics(node: SKSpriteNode) {
        node.physicsBody = SKPhysicsBody(texture: node.texture!, size: node.size)
        node.physicsBody?.affectedByGravity = false
        node.physicsBody?.isDynamic = true // faz reconhecer a colisao
        node.physicsBody?.contactTestBitMask = 1
    }
    
    func setPhysicsObstacles(node: SKSpriteNode) {
        node.physicsBody?.affectedByGravity = false
        node.physicsBody?.isDynamic = true // faz reconhecer a colisao
        node.physicsBody?.linearDamping = 0
        node.physicsBody?.friction = 0
        node.physicsBody?.mass = 1
        node.physicsBody?.categoryBitMask = 1
    }
    
    //MARK: Create Texture
    func createTexture(_ name:String) -> [SKTexture] {
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
    
    #if os(tvOS)
        func addTapGestureRecognizer() {
            self.view?.addGestureRecognizer(gameLogic.addTargetToTapGestureRecognizer())
        }
    #endif
    
    //MARK: - Criação e movimentação de obstáculos
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
        let allObstacles = children.filter { node in node.name == "Enemy" }
        
        gameLogic.calculateObstacleMovement(allObstacles: allObstacles)
    }
    
    func addPauseActionGesture() {
        self.view?.addGestureRecognizer(gameLogic.addTargetToPauseActionToTV())
    }
    
    //MARK: Parallax Background
//    func moveBackground() {
//        scenarioImage.position.x -= (1.5+(CGFloat(gameLogic.score/15)))
//        scenarioImage2.position.x -= (1.5+(CGFloat(gameLogic.score/15)))
//        
//        if scenarioImage.position.x <= -scenarioImage.size.width/2 {
//            scenarioImage.position.x = scenarioImage.size.width/2 + scenarioImage2.position.x*2
//            
//            if gameLogic.score >= 30 && gameLogic.score <= 50 || gameLogic.score >= 80 && gameLogic.score <= 100 {
//                scenarioImage.texture = blueScenarioTexture
//            } else {
//                scenarioImage.texture = greenScenarioTexture
//            }
//        }
//        
//        if scenarioImage2.position.x <= -scenarioImage2.size.width/2 {
//            scenarioImage2.position.x = scenarioImage2.size.width/2 + scenarioImage.position.x*2
//            
//            if gameLogic.score >= 30 && gameLogic.score <= 50 || gameLogic.score >= 80 && gameLogic.score <= 100 {
//                scenarioImage2.texture = blueScenarioTexture
//            } else {
//                scenarioImage2.texture = greenScenarioTexture
//            }
//        }
//    }
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
    
    func gameOver() {
        
    }
    
    func goToHome() {
        let scene = MenuScene.newGameScene()
        view?.presentScene(scene)
    }
    
    func musicAction() -> Void {
        AudioService.shared.toggleMusic(with: self.pauseMenu.musicButton)
    }
    
    func soundAction() -> Void {
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
}



#if os(tvOS)
    extension GameScene {
        override var preferredFocusEnvironments: [UIFocusEnvironment] {
            return [pauseMenu.resumeButton]
        }
    }
#endif

