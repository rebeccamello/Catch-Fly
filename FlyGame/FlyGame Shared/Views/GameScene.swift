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
        var bug = SKSpriteNode(imageNamed: "Mosca")
        bug.zPosition = 1
        bug.name = "Fly"
        bug.setScale(0.8)
        setPhysics(node: bug)
        
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
    
    func setUpScene() {
        removeAllChildren()
        removeAllActions()
        
        self.addChild(scenarioImage)
        scenarioImage.size.width = self.size.width
        scenarioImage.size.height = self.size.height
        scenarioImage.position = CGPoint(x: scenarioImage.size.width/2, y: scenarioImage.size.height/2)
        
        self.addChild(playerNode)
//        comodaVaso = createObstacle(obstacle: Obstacle(lanePosition: self.size.height/3, weight: 2, width: 2, assetName: "comodaVaso"))
//        lustre = createObstacle(obstacle: Obstacle(lanePosition: self.size.height/6*5, weight: 1, width: 1, assetName: "lustre"))
        
        let swipeUp : UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeUp.direction = .up
        
        let swipeDown: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeDown.direction = .down
        
        self.view?.addGestureRecognizer(swipeUp)
        self.view?.addGestureRecognizer(swipeDown)
    }
    
    override func didMove(to view: SKView) {
        self.setUpScene()
        gameLogic.startUp()
        physicsWorld.contactDelegate = self
    }
    
    override func didChangeSize(_ oldSize: CGSize) {
        self.setUpScene()
        playerNode.position = CGPoint(x: size.width/4, y: size.height/2)
        
        startMovement()
        for obstacle in allObstacles {
            obstacle.position = CGPoint(x: size.width - obstacle.size.width/2, y: obstacle.position.y)
        }
    }
       
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
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
    
    func setPhysics(node: SKSpriteNode) {
        node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
        node.physicsBody?.affectedByGravity = false // faz continuar a colisao mas sem cair
        node.physicsBody?.isDynamic = true // faz reconhecer a colisao
        node.physicsBody?.contactTestBitMask = node.physicsBody!.collisionBitMask
        node.physicsBody?.restitution = 0.4
    }
    
    func createObstacle(obstacle: Obstacle) -> SKSpriteNode {
        let enemy = SKSpriteNode(imageNamed: obstacle.assetName)
        enemy.zPosition = 2
        enemy.name = "Enemy"
        enemy.size.height = self.size.height/3 * CGFloat(obstacle.weight)
        enemy.size.width = self.size.width/3.2 * CGFloat(obstacle.weight)
        setPhysics(node: enemy)
//        enemy.position.y = obstacle.lanePosition
        enemy.position = CGPoint(x: size.width + enemy.size.width, y: size.height * obstacle.lanePosition / 6)
        addChild(enemy)
        allObstacles.append(enemy)
        return enemy
    }
    
    
    func startMovement() {
        print("entrou")
        var node = SKSpriteNode()
        let spawn = SKAction.run {
            node = self.createObstacle(obstacle: Obstacle(lanePosition: 1, weight: 1, width: 1, assetName: "Comoda"))
        }
        
        let delay = SKAction.wait(forDuration: 4)
        let spawnDelay = SKAction.sequence([spawn, delay])
        let spawnDelayForever = SKAction.repeatForever(spawnDelay)
        self.run(spawnDelayForever)
        
        let distance = CGFloat(self.frame.width + node.frame.width)
        let moveObs = SKAction.moveBy(x: distance - 50, y: 0, duration: TimeInterval(0.008 * distance))
        let removeObs = SKAction.removeFromParent()
        moveAndRemove = SKAction.sequence([moveObs, removeObs])
    }
}

extension GameScene: GameLogicDelegate {
    func resumeGame() {
        print("resume")
    }
    
    func pauseGame() {
        print("pause")
    }
    
    func gameOver() {
        print("gameOver")
    }
    
    func obstacleSpeed(speed: CGFloat) {
        for obstacle in allObstacles {
            obstacle.position.x -= speed 
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
