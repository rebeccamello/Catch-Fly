//
//  GameOverScene.swift
//  FlyGame
//
//  Created by Nathalia do Valle Papst on 07/03/22.
//

import SpriteKit

class GameOverScene: SKScene {
    
    /* MARK: - Atributos */
    
    #if os(tvOS)
    override var preferredFocusEnvironments: [UIFocusEnvironment] {
        return [homeButton]
    }
    #endif
    
    var score: Int = 20
    
    lazy var gameLogic = GameSceneController()
    
    lazy var scenarioImage = SKSpriteNode(imageNamed: "cenario")
    
    lazy var floor = SKSpriteNode(imageNamed: "floor")
        
    lazy var cat: SKSpriteNode = {
        var cat = SKSpriteNode(imageNamed: "gatoMosca0")
        cat.texture?.filteringMode = .nearest
        
        cat.run(SKAction.creatAnimation(by: "GatoMosca", time: 0.2))
        return cat
    }()
    
    lazy var gameOverLabel: SKLabelNode = {
        var lbl = SKLabelNode()
        lbl.numberOfLines = 0
        lbl.fontColor = UIColor.init(named: "GameOverRed")
        lbl.fontName = "munro"
        lbl.text = "Game Over"
        return lbl
    }()
    
    lazy var scoreLabel: SKLabelNode = {
        var lbl = SKLabelNode()
        lbl.numberOfLines = 0
        lbl.fontColor = SKColor.black
        lbl.fontName = "munro"
        return lbl
    }()
    
    lazy var homeButton = SKButtonNode(image: .menu) {
        self.goToMenu()
    }
    
    lazy var retryButton = SKButtonNode(image: .restart) {
        self.restartGame()
    }
    
    lazy var gameOver: GameOverSceneController = {
        let g = GameOverSceneController()
        g.gameOverDelegate = self
        return g
    }()
    
    class func newGameScene() -> GameOverScene {
        let scene = GameOverScene()
        scene.scaleMode = .resizeFill
        return scene
    }
    
    /* MARK: - Ciclo de Vida */
    
    override func didChangeSize(_ oldSize: CGSize) {
        setupNodesPosition()
        setupNodesSize()
    }
    
    override func didMove(to view: SKView) {
        setUpScene()
        updateScore()
        
        #if os(tvOS)
        addTapGestureRecognizer()
        #endif
        
    }
    
    /* MARK: - Métodos */
    
    func setUpScene() {
        self.addChild(scenarioImage)
        self.addChild(floor)
        self.addChild(cat)
        self.addChild(gameOverLabel)
        self.addChild(scoreLabel)
        self.addChild(homeButton)
        self.addChild(retryButton)
    }
        
    func updateScore() {
        let currentScore = UserDefaults.getIntValue(with: .gameScore)
        scoreLabel.text = "your_score".localized() + "\(currentScore)"
        
        gameOver.scoreHandler(with: currentScore)
    }
    
    private func setupNodesPosition() {
        scenarioImage.setPositions(x: self.size.width/2, y: self.size.height/2, z: 0)
        
        floor.setPositions(x: scenarioImage.position.x, y: scenarioImage.position.y, z: 0)
        
        cat.setPositions(x: self.size.width/4, y: floor.size.height, z: 2)
        
        gameOverLabel.setPositions(x: self.size.width * 0.71, y: self.size.height * 0.67, z: 2)
        
        gameOverLabel.setPositions(x: self.size.width * 0.71, y: self.size.height * 0.67, z: 2)
        
        scoreLabel.setPositions(x: gameOverLabel.position.x, y: self.size.height * 0.55, z: 2)
        
        homeButton.setPositions(
            x: gameOverLabel.position.x - self.size.width * 0.055,
            y: self.size.height * 0.42,
            z: 2
        )
        
        retryButton.setPositions(
            x: gameOverLabel.position.x + self.size.width * 0.055,
            y: self.size.height * 0.42,
            z: 2
        )
    }
    
    private func setupNodesSize() {
        scenarioImage.size = CGSize(width: self.size.width, height: self.size.height)
        
        floor.size = CGSize(width: self.size.width, height: self.size.height * 0.3)
        
        cat.setScale(self.size.height/700)
        gameOverLabel.setScale(self.size.height * 0.006)
        scoreLabel.setScale(self.size.height * 0.003)
        
        let scale = self.size.width * 0.00021
        homeButton.setScale(scale)
        retryButton.setScale(scale)
        
        #if os(iOS)
        if UIDevice.current.userInterfaceIdiom == .pad {
            gameOverLabel.setScale(self.size.height * 0.0055)
            scoreLabel.setScale(self.size.height * 0.0027)
            cat.setScale(self.size.height/800)
        }
        #endif
    }
    
    func addTapGestureRecognizer() {
        self.view?.addGestureRecognizer(gameOver.getTvControlTapRecognizer())
    }
}

extension GameOverScene: GameOverLogicDelegate {
    func restartGame() {
        let scene = GameScene.newGameScene()
        scene.gameLogic.isGameStarted = true
        self.view?.presentScene(scene)
    }
    
    func getButtons() -> [SKButtonNode] {
        return [homeButton, retryButton]
    }
    
    func goToMenu() {
        let scene = MenuScene.newGameScene()
        self.view?.presentScene(scene)
        
        #if os(tvOS)
        scene.run(SKAction.wait(forDuration: 0.02)) {
            scene.view?.window?.rootViewController?.setNeedsFocusUpdate()
            scene.view?.window?.rootViewController?.updateFocusIfNeeded()
        }
        #endif
    }
}
