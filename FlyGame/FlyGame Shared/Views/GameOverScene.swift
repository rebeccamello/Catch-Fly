//
//  GameOverScene.swift
//  FlyGame
//
//  Created by Nathalia do Valle Papst on 07/03/22.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene {
    let tapGeneralSelection = UITapGestureRecognizer()
    
    lazy var scenarioImage: SKSpriteNode = {
        var scenario = SKSpriteNode(imageNamed: "cenario")
        return scenario
    }()
    
    lazy var floor: SKSpriteNode = {
        var floor = SKSpriteNode(imageNamed: "floor")
        return floor
    }()
    
    lazy var cat: SKSpriteNode = {
        var cat = SKSpriteNode(imageNamed: "gatoMosca0")
        cat.texture?.filteringMode = .nearest
        
        let frames:[SKTexture] = createTexture("GatoMosca")
        cat.run(SKAction.repeatForever(SKAction.animate(with: frames,
                                                            timePerFrame: TimeInterval(0.2),
                                                            resize: false, restore: true)))
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
        lbl.text = "Your Score: "
        return lbl
    }()
    
    lazy var homeButton: SKButtonNode = {
        let but = SKButtonNode(image: SKSpriteNode(imageNamed: "menuBotao")) {
            self.goToMenu()
        }
        return but
    }()
    
    lazy var retryButton: SKButtonNode = {
        let but = SKButtonNode(image: SKSpriteNode(imageNamed: "recomecarBotao")) {
            self.restartGame()
        }
        return but
    }()
    
    class func newGameScene() -> GameOverScene {
        let scene = GameOverScene()
        scene.scaleMode = .resizeFill
        return scene
    }

    func setUpScene() {
        self.addChild(scenarioImage)
        self.addChild(floor)
        self.addChild(cat)
        self.addChild(gameOverLabel)
        self.addChild(scoreLabel)
        self.addChild(homeButton)
        self.addChild(retryButton)
    }
    
    func createTexture(_ name:String) -> [SKTexture] {
        let textureAtlas = SKTextureAtlas(named: name)
        var frames = [SKTexture]()
        for i in 1...textureAtlas.textureNames.count - 1 {
            frames.append(textureAtlas.textureNamed(textureAtlas.textureNames[i]))
        }
        return frames
    }
    
    override func didMove(to view: SKView) {
        self.setUpScene()
        
#if os(tvOS)
        addTapGestureRecognizer()
#endif
    }
    
    override func didChangeSize(_ oldSize: CGSize) {
        setupNodesPosition()
        setupNodesSize()
    }
    
    func goToMenu() {
        let scene = MenuScene.newGameScene()
        self.view?.presentScene(scene)
    }
    
    private func setupNodesPosition() {
        scenarioImage.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        scenarioImage.zPosition = 0
        
        floor.position = CGPoint(x: self.size.width/2, y: floor.size.height/2)
        floor.zPosition = 1
        
        cat.position = CGPoint(x: self.size.width/4, y: floor.size.height)
        cat.zPosition = 2
        
        gameOverLabel.position = CGPoint(x: self.size.width * 0.71, y: self.size.height * 0.67)
        gameOverLabel.zPosition = 2
        
        scoreLabel.position = CGPoint(x: gameOverLabel.position.x, y: self.size.height * 0.55)
        scoreLabel.zPosition = 2
        
        homeButton.position = CGPoint(x: gameOverLabel.position.x - self.size.width * 0.055, y: self.size.height * 0.42)
        homeButton.zPosition = 2
        
        retryButton.position = CGPoint(x: gameOverLabel.position.x + self.size.width * 0.055, y: self.size.height * 0.42)
        retryButton.zPosition = 2
        
    }
    
    private func setupNodesSize() {
        scenarioImage.size.width = self.size.width
        scenarioImage.size.height = self.size.height
        
        floor.size.width = self.size.width
        floor.size.height = self.size.height * 0.3
        
        cat.setScale(self.size.height/700)
        gameOverLabel.setScale(self.size.height * 0.006)
        scoreLabel.setScale(self.size.height * 0.003)
        homeButton.setScale(self.size.width * 0.00021)
        retryButton.setScale(self.size.width * 0.00021)
    }
#if os(tvOS)
    func addTapGestureRecognizer(){
        tapGeneralSelection.addTarget(self, action: #selector(clicked))
        self.view?.addGestureRecognizer(tapGeneralSelection)
    }
    
    @objc func clicked() {
        
        if homeButton.isFocused {
            goToMenu()
            
        } else if retryButton.isFocused {
            self.restartGame()
        }
    }
#endif
}

extension GameOverScene: GameOverLogicDelegate {
    
    func restartGame() {
        let scene = GameScene.newGameScene()
        scene.isGameStarted = true
        self.view?.presentScene(scene)
    }
}

#if os(tvOS)
extension GameOverScene {
    override var preferredFocusEnvironments: [UIFocusEnvironment] {
        return [homeButton]
    }
}
#endif

