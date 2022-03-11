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
        bug.physicsBody = SKPhysicsBody(rectangleOf: bug.size)
        bug.physicsBody?.affectedByGravity = false // faz continuar a colisao mas sem cair
        bug.physicsBody?.isDynamic = true // faz reconhecer a colisao
        bug.physicsBody!.contactTestBitMask = bug.physicsBody!.collisionBitMask
        bug.physicsBody?.restitution = 0.4
        
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
    
    func createObstacle(obstacle: Obstacle) -> SKSpriteNode {
        let enemy = SKSpriteNode(imageNamed: obstacle.assetName)
        enemy.zPosition = 2
        enemy.name = "Enemy"
        enemy.size.height = self.size.height/3 * CGFloat(obstacle.weight)
        enemy.size.width = self.size.height/3 * CGFloat(obstacle.weight)
        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
        enemy.physicsBody?.affectedByGravity = false // faz continuar a colisao mas sem cair
        enemy.physicsBody?.isDynamic = true // faz reconhecer a colisão
        if let colisionBitMask = enemy.physicsBody?.collisionBitMask {
            enemy.physicsBody?.contactTestBitMask = colisionBitMask
        }
        enemy.physicsBody?.restitution = 0.4
        enemy.position.y = (self.size.height/6) * CGFloat(obstacle.lanePosition)
        addChild(enemy)
        allObstacles.append(enemy)
        return enemy
    }
    
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
        
        let fetcher = ObstacleFetcher()
        
//        comodaVaso = createObstacle(obstacle: Obstacle(lanePosition: 2, weight: 2, width: 2, assetName: "comodaVaso"))
//        lustre = createObstacle(obstacle: Obstacle(lanePosition: 5, weight: 1, width: 1, assetName: "lustre"))
        comodaVaso = createObstacle(obstacle: fetcher.fetch(lane: 2, weight: 2))
        lustre = createObstacle(obstacle: fetcher .fetch(lane: 5, weight: 1))
        
//        gameLogic.newChoose().forEach { obstacle in
//            createObstacle(obstacle: obstacle)
//        }
        print(gameLogic.chooseObstacle())
        
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
