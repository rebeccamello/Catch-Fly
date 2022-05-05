//
//  TutorialScene.swift
//  FlyGame
//
//  Created by Caroline Taus on 24/03/22.
//

import SpriteKit

class TutorialScene: SKScene {
    
    /* MARK: - Atributos */
    
    var hideTutorial: Bool = false
    
    lazy var gameLogic: TutorialSceneController = {
        let game = TutorialSceneController()
        game.tutorialDelegate = self
        return game
    }()
    
    lazy var scenarioImage = SKSpriteNode(imageNamed: "cenario")
    
    lazy var playerNode: SKSpriteNode = {
        var bug = SKSpriteNode(imageNamed: "mosca")
        bug.texture?.filteringMode = .nearest
        bug.name = "Fly"
        
        bug.run(SKAction.creatAnimation(by: "Mosca", time: 0.05))
        return bug
    }()
    
    lazy var tutorialHandUp: SKSpriteNode = {
        var hand = SKSpriteNode(imageNamed: "tut1")
        hand.texture?.filteringMode = .nearest
        
        hand.run(SKAction.creatAnimation(by: "Tutorial", time: 0.2))
        return hand
    }()
    
    lazy var tutorialHandDown: SKSpriteNode = {
        var hand = SKSpriteNode(imageNamed: "maoBaixo1")
        hand.texture?.filteringMode = .nearest
        
        hand.run(SKAction.creatAnimation(by: "TutorialDown", time: 0.2))
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
    
    /* MARK: - Ciclo de Vida */
    
    override func didMove(to view: SKView) {
        setupObstacles()
        gameLogic.shouldMoveObstacle()
    }
    
    override func didChangeSize(_ oldSize: CGSize) {
        setUpScene()
        setNodePosition()
    }
    
    override func update(_ currentTime: TimeInterval) {
        removeObstacles()
    }
    
    /* MARK: - Métodos */
    
    func setUpScene() {
        removeAllChildren()
        removeAllActions()
        
        addChild(scenarioImage)
        addChild(playerNode)
        addChild(tutorialHandUp)
        addSwipeGesture()
    }
    
    func addSwipeGesture() {
        self.view?.addGestureRecognizer(gameLogic.setSwipeGesture()[0])
        self.view?.addGestureRecognizer(gameLogic.setSwipeGesture()[1])
    }

    func setNodePosition() {
        scenarioImage.size = CGSize(width: self.size.width * 1.2, height: self.size.height)
        scenarioImage.setPositions(x: scenarioImage.size.width/2, y: scenarioImage.size.height/2, z: -1)
        
        var size: CGFloat = self.size.height/5.2
        playerNode.size = CGSize(width: size, height: size)
        playerNode.setPositions(x: self.size.width/4, y: self.size.height/2, z: 1)
        
        size = self.size.width/2
        tutorialHandUp.setPositions(x: size, y: self.size.height * 0.6, z: 3)
        tutorialHandUp.setScale(self.size.height*0.0035)
        
        tutorialHandDown.setPositions(x: size, y: self.size.height * 0.4, z: 3)
        tutorialHandDown.setScale(self.size.height*0.0035)
        
        successLabel.setPositions(x: size, y: self.size.height/2)
        successLabel.fontSize = self.size.height/5
        
        #if os(iOS)
        if UIDevice.current.userInterfaceIdiom == .pad {
            let scale = self.size.height*0.0025
            tutorialHandUp.setScale(scale)
            tutorialHandDown.setScale(scale)
        }
        #endif
    }
    
    func setupObstacles() {
        let screenSize: CGSize = .screenSize()
        let laneSize = Int(screenSize.height/3)
        
        gameLogic.obstacles = [
            Obstacle(lanePosition: 2, weight: 2, width: 2, image: "piano", laneSize: laneSize),
            Obstacle(lanePosition: 5, weight: 1, width: 1, image: "lustre", laneSize: laneSize),
            Obstacle(lanePosition: 4, weight: 2, width: 1, image: "estanteDeCha", laneSize: laneSize)
        ]
    }
    
    func removeObstacles() {
        var outOfTheScreenNodes: [SKNode] = []
        
        for node in self.children where gameLogic.passedObstacles(node: node) {
            outOfTheScreenNodes.append(node)
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
        enemy.name = "Enemy"
        
        enemy.physicsBody = obstacle.physicsBody.copy() as? SKPhysicsBody
        enemy.physicsBody?.affectedByGravity = false
        
        let size: Int = Int(self.size.height/3)
        enemy.size = CGSize(width: size*obstacle.width, height: size*obstacle.weight)
        enemy.setPositions(
            x: self.size.width + enemy.size.width,
            y: self.size.height * CGFloat(obstacle.lanePosition) / 6,
            z: 2
        )
        addChild(enemy)
    }
    
    // MARK: Move obstacles
    func moveObstacle() {
        for obstacle in self.children where obstacle.name == "Enemy" {
            obstacle.run(SKAction.moveTo(x: (self.size.width/2), duration: 1.5))
        }
    }
    
    func moveObstacleOffScreen() {
        var duration: CGFloat = 30
        #if os(tvOS)
        duration = 15
        #endif
        
        for obstacle in self.children where obstacle.name == "Enemy" {
            obstacle.run(SKAction.moveTo(x: (-10000), duration: duration))
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
