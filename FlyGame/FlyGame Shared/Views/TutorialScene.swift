//
//  TutorialScene.swift
//  FlyGame
//
//  Created by Caroline Taus on 24/03/22.
//

import Foundation
import SpriteKit

class TutorialScene: SKScene {
    var obstacleIndex: Int = -1
    var obstacles: [Obstacle] = []
    var defaults = UserDefaults.standard
    var hideTutorial: Bool = false
    
    lazy var scenarioImage: SKSpriteNode = {
        var scenario = SKSpriteNode()
        scenario = SKSpriteNode(imageNamed: "cenario")
        scenario.zPosition = -1
        return scenario
    }()
    
    lazy var gameLogic: TutorialSceneController = {
        let g = TutorialSceneController()
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
        hand.zPosition = 3
        hand.texture?.filteringMode = .nearest
        let frames:[SKTexture] = createTexture("Tutorial")
        hand.run(SKAction.repeatForever(SKAction.animate(with: frames,
                                                        timePerFrame: TimeInterval(0.2),
                                                        resize: false, restore: true)))
        return hand
    }()
    
    class func newGameScene() -> TutorialScene {
        let scene = TutorialScene()
        scene.scaleMode = .resizeFill
        return scene
    }
    
    override func didMove(to view: SKView) {
        setUpScene()
        shouldMoveObstacle()
    }
    
    func setUpScene() {
        removeAllChildren()
        removeAllActions()
        
        self.addChild(scenarioImage)
        self.addChild(playerNode)
        self.addChild(tutorialNode)

        setSwipeGesture()
        
        let screenSize: CGSize = .screenSize()
        let laneHeight = screenSize.height/3
        
        obstacles = [Obstacle(lanePosition: 2, weight: 2, width: 2, assetName: "piano", physicsBody: SKPhysicsBody(texture: SKTexture(imageNamed: "piano"), size: CGSize(width: laneHeight*2, height: laneHeight*2))), Obstacle(lanePosition: 5, weight: 1, width: 1, assetName: "lustre", physicsBody: SKPhysicsBody(texture: SKTexture(imageNamed: "lustre"), size: CGSize(width: laneHeight, height: laneHeight))), Obstacle(lanePosition: 4, weight: 2, width: 1, assetName: "estanteDeCha", physicsBody: SKPhysicsBody(texture: SKTexture(imageNamed: "estanteDeCha"), size: CGSize(width: laneHeight, height: laneHeight*2))) ]
    }
    
    override func didChangeSize(_ oldSize: CGSize) {
        setUpScene()
        setNodePosition()
    }
    
    func setNodePosition() {
        scenarioImage.size.width = self.size.width * 1.2
        scenarioImage.size.height = self.size.height
        scenarioImage.position = CGPoint(x: scenarioImage.size.width/2, y: scenarioImage.size.height/2)
        playerNode.size.height = self.size.height/5.2
        playerNode.size.width = self.size.height/5.2
        playerNode.position = CGPoint(x: size.width/4, y: size.height/2)
        tutorialNode.position = CGPoint(x: size.width/2, y: size.height * 0.6)
        tutorialNode.setScale(self.size.height*0.0035)
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
    
    func setSwipeGesture() {
        let swipeUp : UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeUp.direction = .up
        
        let swipeDown: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeDown.direction = .down
        
        self.view?.addGestureRecognizer(swipeUp)
        self.view?.addGestureRecognizer(swipeDown)
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        guard
            let swipeGesture = gesture as? UISwipeGestureRecognizer,
            let direction = swipeGesture.direction.direction
        else { return }
        movePlayer(direction: direction)
        shouldMoveObstacle()
        defaults.set(true, forKey: "playerFirstTime")
        }
    
    func movePlayer(direction: Direction) {
        let position = gameLogic.movePlayer(direction: direction)
        let moveAction = SKAction.moveTo(y: position * (size.height / 6), duration: 0.1)
        moveAction.timingMode = .easeOut
        playerNode.run(moveAction)
        AudioService.shared.soundManager(with: .swipe, soundAction: .play)
    }
    
    //MARK: - Criação e movimentação de obstáculos
    func createObstacle(obstacle: Obstacle) {
        let enemy = SKSpriteNode(imageNamed: obstacle.assetName)
        enemy.physicsBody = obstacle.physicsBody.copy() as? SKPhysicsBody
        enemy.physicsBody?.affectedByGravity = false
        enemy.zPosition = 2
        enemy.name = "Enemy"
        enemy.size.height = self.size.height/3 * CGFloat(obstacle.weight)
        enemy.size.width = self.size.height/3 * CGFloat(obstacle.width)
        enemy.position = CGPoint(x: size.width + enemy.size.width, y: size.height * CGFloat(obstacle.lanePosition) / 6)
        addChild(enemy)
        
    }
    override func update(_ currentTime: TimeInterval) {
//        shouldMoveObstacle()
        
        //MARK: Deleta nodes fora da tela
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
    }
    
    func shouldMoveObstacle() {
        if obstacleIndex == -1 {
            print("1 if ")
            obstacleIndex += 1
            createObstacle(obstacle: obstacles[0])
            moveObstacle()
        }
        
        else if obstacleIndex == 0 && gameLogic.currentPosition == 5 { //piano
            print("2 if ")
            moveObstacleOffScreen()
            obstacleIndex += 1
            createObstacle(obstacle: obstacles[1])
            moveObstacle()
        }
        else if obstacleIndex == 1 && gameLogic.currentPosition == 3 {
            print("3 if ")
            moveObstacleOffScreen()
            obstacleIndex += 1
            createObstacle(obstacle: obstacles[2])
            moveObstacle()
        }
        else if obstacleIndex == 2 && gameLogic.currentPosition == 1 {
            print("4 if ")
            moveObstacleOffScreen()
            obstacleIndex += 1
        }
        
    }
    
    func moveObstacle() {
        let allObstacles = children.filter { node in node.name == "Enemy" }
        for obstacle in allObstacles {
            let moveObstAction = SKAction.moveTo(x: (self.size.width/2), duration: 3)
            obstacle.run(moveObstAction)
        }
    }
    
    func moveObstacleOffScreen() {
        let allObstacles = children.filter { node in node.name == "Enemy" }
        for obstacle in allObstacles {
            let moveObstAction = SKAction.moveTo(x: (-self.size.width/2), duration: 200)
                obstacle.run(moveObstAction)
            
        }
    }
    
    
    
}
