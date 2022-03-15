//
//  GameScene.swift
//  FlyGame Shared
//
//  Created by Nathalia do Valle Papst on 07/03/22.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var currentPosition: CGFloat = 3
    
    var comodaVaso: SKSpriteNode = SKSpriteNode()
    var lustre: SKSpriteNode = SKSpriteNode()
    var allObstacles: [SKSpriteNode] = []
    var moveAndRemove = SKAction()
    lazy var pauseButton: SKButtonNode = {
        let but = SKButtonNode(image: SKSpriteNode(imageNamed: "pauseBotao"), action: {
            self.pauseMenu.isHidden.toggle()
            self.isPaused.toggle()
        })
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
        bug.setScale(0.7)
        
        
        let texture: [SKTexture] = [SKTexture(imageNamed: "mosca0.png"),
                                    SKTexture(imageNamed: "mosca1.png"),
                                    SKTexture(imageNamed: "mosca2.png"),
                                    SKTexture(imageNamed: "mosca3.png"),
                                    SKTexture(imageNamed: "mosca4.png"),
                                    SKTexture(imageNamed: "mosca5.png")]
        for t in texture{
            t.filteringMode = .nearest
        }
        let idleAnimation = SKAction.animate(with: texture, timePerFrame: 0.04)
        let loop = SKAction.repeatForever(idleAnimation)
        bug.run(loop)
        
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
        
        self.addChild(scenarioImage)
        scenarioImage.size.width = self.size.width
        scenarioImage.size.height = self.size.height
        scenarioImage.position = CGPoint(x: scenarioImage.size.width/2, y: scenarioImage.size.height/2)
        
        self.addChild(playerNode)
        self.addChild(pauseButton)
        self.addChild(pauseMenu)
        
        
        print(gameLogic.chooseObstacle())
        
        let swipeUp : UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeUp.direction = .up
        
        let swipeDown: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeDown.direction = .down
        
        self.view?.addGestureRecognizer(swipeUp)
        self.view?.addGestureRecognizer(swipeDown)
        
        pauseMenu.isHidden = true
    }
    
    //MARK: - didMove
    override func didMove(to view: SKView) {
        self.setUpScene()
        gameLogic.startUp()
        physicsWorld.contactDelegate = self
    }
    
    //MARK: didChangeSize
    override func didChangeSize(_ oldSize: CGSize) {
        self.setUpScene()
        self.setNodePosition()
        
        startMovement()
        setPhysics(node: playerNode)
    }
    
    func setPhysics(node: SKSpriteNode) {
        node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
        node.physicsBody?.affectedByGravity = false // faz continuar a colisao mas sem cair
        node.physicsBody?.isDynamic = true // faz reconhecer a colisao
        node.physicsBody?.contactTestBitMask = node.physicsBody!.collisionBitMask
        node.physicsBody?.restitution = 0.4
    }
    
    func setNodePosition() {
        playerNode.size.height = self.size.height/5
        playerNode.size.width = self.size.height/5
        playerNode.position = CGPoint(x: size.width/4, y: size.height/2)
        pauseMenu.position = CGPoint(x: size.width/2, y: size.height/2)
        pauseButton.position = CGPoint(x: size.width*0.06, y: size.height*0.88)
        
        pauseButton.setScale(self.size.height*0.00035)
    }
       
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
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
        let scene = GameOverScene.newGameScene()
        view?.presentScene(scene)
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        guard
            let swipeGesture = gesture as? UISwipeGestureRecognizer,
            let direction = swipeGesture.direction.direction
        else { return }
        
        gameLogic.movePlayer(direction: direction, position: Int(currentPosition))
    }
    
    //MARK: - Criação e movimentação de obstáculos
    func createObstacle(obstacle: Obstacle) -> SKSpriteNode {
        let enemy = SKSpriteNode(imageNamed: obstacle.assetName)
        enemy.zPosition = 2
        enemy.name = "Enemy"
        enemy.size.height = self.size.height/3.1 * CGFloat(obstacle.weight)
        enemy.size.width = self.size.height/3.1 * CGFloat(obstacle.width)
        setPhysics(node: enemy)
        enemy.position = CGPoint(x: size.width + enemy.size.width, y: size.height * CGFloat(obstacle.lanePosition) / 6)
        addChild(enemy)
        allObstacles.append(enemy)
        return enemy
    }
    
    func startMovement() {
        var node = SKSpriteNode()
        let spawn = SKAction.run {
            self.gameLogic.chooseObstacle().forEach { obstacle in
                node = self.createObstacle(obstacle: obstacle)
            }
        }
        
        #if os(tvOS)
        let delay = SKAction.wait(forDuration: 8)
        
        #else
        let delay = SKAction.wait(forDuration: 4)
        
        #endif
        let spawnDelay = SKAction.sequence([spawn, delay])
        let spawnDelayForever = SKAction.repeatForever(spawnDelay)
        self.run(spawnDelayForever)

//        let distance = CGFloat(self.frame.width + node.frame.width)
//        let moveObs = SKAction.moveBy(x: distance - 10, y: 0, duration: TimeInterval(0.1 * distance))
//        let removeObs = SKAction.removeFromParent()
//        moveAndRemove = SKAction.sequence([moveObs, removeObs])
//        node.removeFromParent()
    }
}

extension GameScene: GameLogicDelegate {
    func resumeGame() {
        print("resume")
        self.isPaused.toggle()
        pauseMenu.isHidden = true
    }
    
    func pauseGame() {
        print("pause")
    }
    
    func gameOver() {
        print("gameOver")
    }
    
    func goToHome() {
        let scene = MenuScene.newGameScene()
        view?.presentScene(scene)
    }
    
    func retryGame() {
        print("retry")
    }
    
    func sound() {
        print("sound")
    }
    
    func music() {
        print("music")
    }
    
    func obstacleSpeed(speed: CGFloat) {
        for obstacle in allObstacles {
            if isPaused == true{
                obstacle.position.x -= 0
            }
            else{
                obstacle.position.x -= speed
            }
            
        }
    }

    
    func movePlayer(position: Int) {
        playerNode.position.y = CGFloat(position) * (size.height / 6)
        currentPosition = CGFloat(position)
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
