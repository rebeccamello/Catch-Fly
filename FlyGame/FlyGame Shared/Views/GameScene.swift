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
    let buttonTvOS = UITapGestureRecognizer()
    
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
        
#if os(tvOS)
        self.buttonTvOS.addTarget(self, action: #selector(self.tvOSAction))
        self.buttonTvOS.allowedPressTypes = [NSNumber(value: UIPress.PressType.playPause.rawValue)]
        self.view?.addGestureRecognizer(self.buttonTvOS)
        
#endif
        
        self.addChild(scenarioImage)
        scenarioImage.size.width = self.size.width
        scenarioImage.size.height = self.size.height
        scenarioImage.position = CGPoint(x: scenarioImage.size.width/2, y: scenarioImage.size.height/2)
        
        self.addChild(playerNode)
        self.addChild(pauseButton)
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
        }
    }
    
    //MARK: didChangeSize
    override func didChangeSize(_ oldSize: CGSize) {
        self.setUpScene()
        self.setNodePosition()
        
        setPhysics(node: playerNode)
    }
    
    override func update(_ currentTime: TimeInterval) {
        let outOfTheScreenNodes = children.filter { node in
            if let sprite = node as? SKSpriteNode {
                return sprite.position.x < (-1 * (sprite.size.width/2 + 20))
            } else {
                return false
            }
        }
        removeChildren(in: outOfTheScreenNodes)
        gameLogic.update(currentTime: currentTime)
        
    }
    
    func setPhysics(node: SKSpriteNode) {
        node.physicsBody = SKPhysicsBody(texture: node.texture!, size: node.size)
        //node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
        node.physicsBody?.affectedByGravity = false
        node.physicsBody?.isDynamic = true // faz reconhecer a colisao
        node.physicsBody?.contactTestBitMask = 1
    }
    func setPhysicsObstacles(node: SKSpriteNode) {
        node.physicsBody = SKPhysicsBody(texture: node.texture!, size: node.size)
        //node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
        node.physicsBody?.affectedByGravity = false
        node.physicsBody?.isDynamic = true // faz reconhecer a colisao
        node.physicsBody?.linearDamping = 0
        node.physicsBody?.friction = 0
        node.physicsBody?.mass = 1
        node.physicsBody?.categoryBitMask = 1
    }
    
    func setNodePosition() {
        playerNode.size.height = self.size.height/5
        playerNode.size.width = self.size.height/5
        playerNode.position = CGPoint(x: size.width/4, y: size.height/2)
        pauseMenu.position = CGPoint(x: size.width/2, y: size.height/2)
        pauseButton.position = CGPoint(x: size.width*0.06, y: size.height*0.88)
        scoreLabel.position = CGPoint(x: pauseButton.position.x + scoreLabel.frame.size.width/2 + 50, y: pauseButton.position.y - scoreLabel.frame.size.height/2)
        pauseButton.setScale(self.size.height*0.00035)
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
        view?.presentScene(scene)
        
#if os(tvOS)
        scene.run(SKAction.wait(forDuration: 0.02)) {
            scene.view?.window?.rootViewController?.setNeedsFocusUpdate()
            scene.view?.window?.rootViewController?.updateFocusIfNeeded()
        }
#endif
    }
    
#if os(tvOS)
    func addTapGestureRecognizer(){
        buttonTvOS.addTarget(self, action: #selector(clicked))
        self.view?.addGestureRecognizer(buttonTvOS)
    }
    
    @objc func clicked() {
        
        if pauseMenu.resumeButton.isFocused {
            resumeGame()
            
        } else if pauseMenu.homeButton.isFocused {
            goToHome()
            
        }else if pauseMenu.retryButton.isFocused {
            
            
        }else if pauseMenu.soundButton.isFocused {
            
        }else if pauseMenu.musicButton.isFocused {
            
        }
    }
#endif
    
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
        
        enemy.size.height = self.size.height/3.1 * CGFloat(obstacle.weight)
        enemy.size.width = self.size.height/3.1 * CGFloat(obstacle.width)
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
                let moveObstAction = SKAction.moveTo(x: (-100000), duration: gameLogic.duration*100)
                obstacle.run(moveObstAction)
            }
        }
    }
    
    func movePlayer(direction: Direction) {
        let position = gameLogic.movePlayer(direction: direction)
        let moveAction = SKAction.moveTo(y: position * (size.height / 6), duration: 0.08)
        playerNode.run(moveAction)
    }

    
    //MARK: - Função de clicar no botão com tvRemote
    @objc private func tvOSAction() {
        self.pauseGame()
    }
}


extension GameScene: GameLogicDelegate {
    func toggleSound() -> SKButtonNode {
        return pauseMenu.soundButton
    }
    
    func toggleMusic() -> SKButtonNode {
        return pauseMenu.musicButton
    }
    
    
    func drawScore(score: Int) {
        scoreLabel.text = String(score)
    }
    
    func resumeGame() {
        print("resume")
        self.isPaused.toggle()
        pauseMenu.isHidden = true
    }
    
    func pauseGame() {
        self.pauseMenu.isHidden.toggle()
        self.isPaused.toggle()
    }
    
    func gameOver() {
        
    }
    
    func goToHome() {
        let scene = MenuScene.newGameScene()
        view?.presentScene(scene)
    }
    
    //    func obstacleSpeed(speed: CGFloat) {
    
    //        let allObstacles = children.filter { node in node.name == "Enemy" }
    //        for obstacle in allObstacles {
    //            var newPosition = obstacle.position.x
    //
    //            if isPaused == true{
    //                obstacle.position.x -= 0
    //            }
    //            else{
    //                newPosition -= speed
    //                obstacle.physicsBody?.applyForce(CGVector(dx: -100, dy: 0))
    //                //let moveObstAction = SKAction.moveTo(x: (-self.size.width - obstacle.frame.width) , duration: 3)
    //
    //                //obstacle.run(moveObstAction)
    //                //obstacle.position.x -= speed
    //            }
    //        }
    //    }
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
