//
//  TutorialScene.swift
//  FlyGame
//
//  Created by Caroline Taus on 24/03/22.
//

import Foundation
import SpriteKit

class TutorialScene: SKScene {
    
    var hideTutorial: Bool = false
    lazy var scenarioImage: SKSpriteNode = {
        var scenario = SKSpriteNode()
        scenario = SKSpriteNode(imageNamed: "cenario")
        scenario.zPosition = -1
        return scenario
    }()
    lazy var gameLogic: TutorialSceneController = {
        let game = TutorialSceneController()
        game.tutorialDelegate = self
        return game
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
    
    lazy var tutorialHandUp: SKSpriteNode = {
        var hand = SKSpriteNode(imageNamed: "tut1")
        hand.zPosition = 3
        hand.texture?.filteringMode = .nearest
        let frames: [SKTexture] = createTexture("Tutorial")
        hand.run(SKAction.repeatForever(SKAction.animate(with: frames,
                                                         timePerFrame: TimeInterval(0.2),
                                                         resize: false, restore: true)))
        return hand
    }()
    
    lazy var tutorialHandDown: SKSpriteNode = {
        var hand = SKSpriteNode(imageNamed: "maoBaixo1")
        hand.zPosition = 3
        hand.texture?.filteringMode = .nearest
        let frames: [SKTexture] = createTexture("TutorialDown")
        hand.run(SKAction.repeatForever(SKAction.animate(with: frames,
                                                         timePerFrame: TimeInterval(0.2),
                                                         resize: false, restore: true)))
        return hand
    }()
    
    lazy var successLabel: SKLabelNode = {
        var lbl = SKLabelNode()
        lbl.numberOfLines = 0
        lbl.fontColor = SKColor.black
        lbl.fontName = "munro"
        lbl.text = "success".localized()
        return lbl
    }()
    
    class func newGameScene() -> TutorialScene {
        let scene = TutorialScene()
        scene.scaleMode = .resizeFill
        return scene
    }
    
    override func didMove(to view: SKView) {
        setUpScene()
        gameLogic.shouldMoveObstacle()
    }
    func setUpScene() {
        removeAllChildren()
        removeAllActions()
        self.addChild(scenarioImage)
        self.addChild(playerNode)
        self.addChild(tutorialHandUp)
        addSwipeGesture()
        let screenSize: CGSize = .screenSize()
        let laneHeight = screenSize.height/3
        gameLogic.obstacles = [Obstacle(lanePosition: 2, weight: 2, width: 2, assetName: "piano",
                                        physicsBody: SKPhysicsBody(texture: SKTexture(imageNamed: "piano"),
                                                                   size: CGSize(width: laneHeight*2,
                                                                                height: laneHeight*2))),
                               Obstacle(lanePosition: 5, weight: 1, width: 1, assetName: "lustre",
                                        physicsBody: SKPhysicsBody(texture: SKTexture(imageNamed: "lustre"),
                                                                   size: CGSize(width: laneHeight,
                                                                                height: laneHeight))),
                               Obstacle(lanePosition: 4, weight: 2, width: 1, assetName: "estanteDeCha",
                                        physicsBody: SKPhysicsBody(texture: SKTexture(imageNamed: "estanteDeCha"),
                                                                   size: CGSize(width: laneHeight, height: laneHeight*2))) ]
    }
    override func didChangeSize(_ oldSize: CGSize) {
        setUpScene()
        setNodePosition()
    }
    func addSwipeGesture() {
        self.view?.addGestureRecognizer(gameLogic.setSwipeGesture()[0])
        self.view?.addGestureRecognizer(gameLogic.setSwipeGesture()[1])
    }
    
    func setNodePosition() {
        scenarioImage.size.width = self.size.width * 1.2
        scenarioImage.size.height = self.size.height
        scenarioImage.position = CGPoint(x: scenarioImage.size.width/2, y: scenarioImage.size.height/2)
        playerNode.size.height = self.size.height/5.2
        playerNode.size.width = self.size.height/5.2
        playerNode.position = CGPoint(x: size.width/4, y: size.height/2)
        tutorialHandUp.position = CGPoint(x: size.width/2, y: size.height * 0.6)
        tutorialHandUp.setScale(self.size.height*0.0035)
        tutorialHandDown.position = CGPoint(x: size.width/2, y: size.height * 0.4)
        tutorialHandDown.setScale(self.size.height*0.0035)
        successLabel.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        successLabel.fontSize = self.size.height/5
    }
    
    // MARK: Create Texture
    func createTexture(_ name: String) -> [SKTexture] {
        let textureAtlas = SKTextureAtlas(named: name)
        var frames = [SKTexture]()
        for index in 1...textureAtlas.textureNames.count - 1 {
            frames.append(textureAtlas.textureNamed(textureAtlas.textureNames[index]))
        }
        return frames
    }
    
    override func update(_ currentTime: TimeInterval) {
        // MARK: Deleta nodes fora da tela
        removeObstacles()
    }
    
    func removeObstacles() {
        let outOfTheScreenNodes = children.filter { node in
            gameLogic.passedObstacles(node: node)
        }
        
        for node in outOfTheScreenNodes {
            node.physicsBody = nil
        }
        if outOfTheScreenNodes.count >= 1 {
            gameLogic.obstacleIndex += 1
            gameLogic.shouldMoveObstacle()
        }
        removeChildren(in: outOfTheScreenNodes)
        if (playerNode.position.x > self.size.width + 100) { // mosquinha saiu da cena
            gameLogic.state = 8
            gameLogic.shouldMoveObstacle()
        }
    }
}

extension TutorialScene: TutorialDelegate {
    func movePlayer(direction: Direction) {
        let position = gameLogic.movePlayer(direction: direction)
        let moveAction = SKAction.moveTo(y: position * (size.height / 6), duration: 0.1)
        moveAction.timingMode = .easeOut
        playerNode.run(moveAction)
        AudioService.shared.soundManager(with: .swipe, soundAction: .play)
    }
    
    // MARK: - Criação e movimentação de obstáculos
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
    
    // MARK: Move obstacles
    func moveObstacle() {
        let allObstacles = children.filter { node in node.name == "Enemy" }
        for obstacle in allObstacles {
            let moveObstAction = SKAction.moveTo(x: (self.size.width/2), duration: 1.5)
            obstacle.run(moveObstAction)
        }
    }
    
    func moveObstacleOffScreen() {
        let allObstacles = children.filter { node in node.name == "Enemy" }
        for obstacle in allObstacles {
    #if os(iOS)
            let moveObstAction = SKAction.moveTo(x: (-10000), duration: 30)
    #elseif os(tvOS)
            let moveObstAction = SKAction.moveTo(x: (-10000), duration: 15)
    #endif
            obstacle.run(moveObstAction)
        }
    }
    
    func getNodes() -> [SKSpriteNode] {
        return [tutorialHandUp, tutorialHandDown, playerNode]
    }
    
    func addNode(node: SKSpriteNode) {
        addChild(node)
    }
    
    func getLabelNode() -> SKLabelNode {
        return successLabel
    }
    
    func addLabelNode(label: SKLabelNode) {
        addChild(label)
    }
    
    func getScreenSize() -> CGSize {
        return self.size
    }
    
    func presentScene(scene: SKScene) {
        self.view?.presentScene(scene)
    }
}
