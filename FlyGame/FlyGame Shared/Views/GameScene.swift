//
//  GameScene.swift
//  FlyGame Shared
//
//  Created by Nathalia do Valle Papst on 07/03/22.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var moveAndRemove = SKAction()
    var isGameStarted: Bool = false
    private var currentTime: TimeInterval = 0
    
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
        let but = SKButtonNode(image: SKSpriteNode(imageNamed: "pauseBotao"), action: {
            self.pauseMenu.isHidden.toggle()
            self.gameLogic.handlePause(isPaused: !self.isPaused)
            self.isPaused.toggle()
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
                                                            timePerFrame: TimeInterval(0.2),
                                                            resize: false, restore: true)))
        return bug
    }()
    
    class func newGameScene() -> GameScene {
        let scene = GameScene()
        scene.scaleMode = .resizeFill
        return scene
    }
    
    //MARK: - setUpScenne
    func setUpScene() {
        removeAllChildren()
        removeAllActions()
        self.view?.showsPhysics = true
        
        self.addChild(scenarioImage)
        scenarioImage.size.width = self.size.width
        scenarioImage.size.height = self.size.height
        scenarioImage.position = CGPoint(x: scenarioImage.size.width/2, y: scenarioImage.size.height/2)
        
        self.addChild(playerNode)
        
        #if os(iOS)
        self.addChild(pauseButton)
        #endif
        
        self.addChild(pauseMenu)
        self.addChild(scoreLabel)
        
        setSwipeGesture()
        
        pauseMenu.isHidden = true
        pauseMenu.retryButton.action = {
            let scene = GameScene.newGameScene()
            scene.isGameStarted = true
            self.view?.presentScene(scene)
        }
    }
    
    //MARK: - didMove
    override func didMove(to view: SKView) {
        self.setUpScene()
        
        if isGameStarted {
            gameLogic.startUp()
            physicsWorld.contactDelegate = self
            makeBackground()
        }
    }
    
    //MARK: didChangeSize
    override func didChangeSize(_ oldSize: CGSize) {
        self.setUpScene()
        self.setNodePosition()
        
        setPhysics(node: playerNode)
    }
    
    override func update(_ currentTime: TimeInterval) {
        self.currentTime = currentTime
        let outOfTheScreenNodes = children.filter { node in
            if let sprite = node as? SKSpriteNode {
                return sprite.position.x < (-1 * (sprite.size.width/2 + 20))
            } else {
                return false
            }
        }
        
        for node in outOfTheScreenNodes {
            node.physicsBody = nil
        }
        
        removeChildren(in: outOfTheScreenNodes)
        gameLogic.update(currentTime: currentTime)
    }
    
    func setPhysics(node: SKSpriteNode) {
        node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
        node.physicsBody?.affectedByGravity = false
        node.physicsBody?.isDynamic = true // faz reconhecer a colisao
        node.physicsBody?.contactTestBitMask = 1
    }
    
    func setPhysicsObstacles(node: SKSpriteNode) {
        node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
        node.physicsBody?.affectedByGravity = false
        node.physicsBody?.isDynamic = true // faz reconhecer a colisao
        node.physicsBody?.linearDamping = 0
        node.physicsBody?.friction = 0
        node.physicsBody?.mass = 1
        node.physicsBody?.categoryBitMask = 1
    }
    
    func setNodePosition() {
        playerNode.size.height = self.size.height/5.2
        playerNode.size.width = self.size.height/5.2
        playerNode.position = CGPoint(x: size.width/4, y: size.height/2)
        pauseMenu.position = CGPoint(x: size.width/2, y: size.height/2)
        pauseButton.position = CGPoint(x: size.width*0.06, y: size.height*0.88)
        pauseButton.setScale(self.size.height*0.00035)
        scoreLabel.fontSize = self.size.height/15
        
        #if os(iOS)
        scoreLabel.position = CGPoint(x: pauseButton.position.x + scoreLabel.frame.size.width/2 + 50, y: pauseButton.position.y - scoreLabel.frame.size.height/2)
        #elseif os(tvOS)
        scoreLabel.position = pauseButton.position
        #endif
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
    
    //MARK: Gesture
    func setSwipeGesture() {
        let swipeUp : UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeUp.direction = .up
        
        let swipeDown: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeDown.direction = .down
        
        self.view?.addGestureRecognizer(swipeUp)
        self.view?.addGestureRecognizer(swipeDown)
    }
    
    //MARK: - Colisão
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if contact.bodyB.node?.name == "Fly" || contact.bodyA.node?.name == "Fly" {
            collisionBetween(player: nodeA, enemy: nodeB)
        }
    }
    
    func collisionBetween(player: SKNode, enemy: SKNode) {
        gameLogic.tearDown()
        self.isGameStarted = false
        let scene = GameOverScene.newGameScene()
        scene.score = gameLogic.score
        view?.presentScene(scene)
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        guard
            let swipeGesture = gesture as? UISwipeGestureRecognizer,
            let direction = swipeGesture.direction.direction
        else { return }
        movePlayer(direction: direction)
    }
    
    //MARK: - Criação e movimentação de obstáculos
    func createObstacle(obstacle: Obstacle) {
        let enemy = SKSpriteNode(imageNamed: obstacle.assetName)
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
        for obstacle in allObstacles {
            if isPaused == true{
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
    
    func movePlayer(direction: Direction) {
        let position = gameLogic.movePlayer(direction: direction)
        let moveAction = SKAction.moveTo(y: position * (size.height / 6), duration: 0.08)
        playerNode.run(moveAction)
    }
    
    //MARK: Parallax Background
    func makeBackground() {
        let backgroundTexture = SKTexture(imageNamed: "cenario")

        //move background right to left; replace
        let shiftBackground = SKAction.moveBy(x: -backgroundTexture.size().width, y: 0, duration: 9)
        let replaceBackground = SKAction.moveBy(x: backgroundTexture.size().width, y:0, duration: 0)
        let movingAndReplacingBackground = SKAction.repeatForever(SKAction.sequence([shiftBackground,replaceBackground]))

        for i in 0...3 {
            scenarioImage = SKSpriteNode(texture:backgroundTexture)
            scenarioImage.position = CGPoint(x: backgroundTexture.size().width/2 + (backgroundTexture.size().width * CGFloat(i)), y: self.frame.midY)
            scenarioImage.size.height = self.frame.height
            scenarioImage.run(movingAndReplacingBackground)

            self.addChild(scenarioImage)
        }
    }
}

extension GameScene: GameLogicDelegate {
    func drawScore(score: Int) {
        scoreLabel.text = String(score)
    }
    
    func resumeGame() {
        print("resume")
        self.isPaused.toggle()
        self.gameLogic.handlePause(isPaused: isPaused)
        pauseMenu.isHidden = true
    }
    
    func pauseGame() {
        print("pause")
    }
    
    func gameOver() {
        
    }
    
    func goToHome() {
        let scene = MenuScene.newGameScene()
        view?.presentScene(scene)
    }
    
    func sound() {
        print("sound")
    }
    
    func music() {
        print("music")
    }
}

enum Direction {
    case up, down
}

extension UISwipeGestureRecognizer.Direction {
    var direction: Direction? {
        switch self {
        case .up:
            return Direction.up
            
        case .down:
            return Direction.down
            
        default:
            return nil
        }
    }
}
