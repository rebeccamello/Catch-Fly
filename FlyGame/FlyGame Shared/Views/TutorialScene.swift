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
    
    lazy var tutorialHandUp: SKSpriteNode = {
        var hand = SKSpriteNode(imageNamed: "tut1")
        hand.zPosition = 3
        hand.texture?.filteringMode = .nearest
        let frames:[SKTexture] = createTexture("Tutorial")
        hand.run(SKAction.repeatForever(SKAction.animate(with: frames,
                                                         timePerFrame: TimeInterval(0.2),
                                                         resize: false, restore: true)))
        return hand
    }()
    
    lazy var tutorialHandDown: SKSpriteNode = {
        var hand = SKSpriteNode(imageNamed: "maoBaixo1")
        hand.zPosition = 3
        hand.texture?.filteringMode = .nearest
        let frames:[SKTexture] = createTexture("TutorialDown")
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
        shouldMoveObstacle()
    }
    
    func setUpScene() {
        removeAllChildren()
        removeAllActions()
        
        self.addChild(scenarioImage)
        self.addChild(playerNode)
        self.addChild(tutorialHandUp)
        
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
        tutorialHandUp.position = CGPoint(x: size.width/2, y: size.height * 0.6)
        tutorialHandUp.setScale(self.size.height*0.0035)
        tutorialHandDown.position = CGPoint(x: size.width/2, y: size.height * 0.4)
        tutorialHandDown.setScale(self.size.height*0.0035)
        successLabel.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        successLabel.fontSize = self.size.height/5
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
        
        if outOfTheScreenNodes.count >= 1 {
            obstacleIndex += 1
            shouldMoveObstacle()
        }
        removeChildren(in: outOfTheScreenNodes)
        
        if (playerNode.position.x > self.size.width + 100) { // mosquinha saiu da cena
            state = 8
            shouldMoveObstacle()
        }
    }
    
    //MARK: Should move obstacle
    var state = 0
    func shouldMoveObstacle() {
        if obstacleIndex == -1 { // piano entra
            obstacleIndex += 1
            createObstacle(obstacle: obstacles[0])
            moveObstacle()
            state += 1
        }
        
        else if obstacleIndex == 0 && gameLogic.currentPosition == 5 && state == 1 { //piano sai
            moveObstacleOffScreen()
            state += 1
            tutorialHandUp.isHidden = true
        }
        
        else if obstacleIndex == 1 && state == 2 { // entra lustre
            self.addChild(tutorialHandDown)
            createObstacle(obstacle: obstacles[1])
            moveObstacle()
            state += 1
        }
        
        else if obstacleIndex == 1 && (gameLogic.currentPosition == 3 || gameLogic.currentPosition == 1) && state == 3 { // sair lustre
            tutorialHandDown.isHidden = true
            moveObstacleOffScreen()
            state += 1
        }
        
        else if obstacleIndex == 2 && state == 4 { // entra xicara
            tutorialHandDown.isHidden = false
            createObstacle(obstacle: obstacles[2])
            moveObstacle()
            state += 1
        }
        
        else if obstacleIndex == 2 && gameLogic.currentPosition == 1 && state == 5 { //sai xicara
            tutorialHandDown.isHidden = true
            moveObstacleOffScreen()
            state += 1
        }
        
        else if state == 6 {
            addChild(successLabel)
            state += 1
            shouldMoveObstacle()
        }
        
        else if state == 7 {
            let flyFly = SKAction.moveTo(x: self.size.width + 500, duration: 3)
            playerNode.run(flyFly)
        }
        
        else if state == 8 {
            let scene = GameScene.newGameScene()
            scene.isGameStarted = true
            self.view?.presentScene(scene)
        }
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
            let moveObstAction = SKAction.moveTo(x: (-10000), duration: 30)
            obstacle.run(moveObstAction)
        }
    }
    
}
