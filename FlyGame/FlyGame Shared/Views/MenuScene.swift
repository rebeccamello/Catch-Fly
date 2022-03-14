//
//  MenuScene.swift
//  FlyGame
//
//  Created by Nathalia do Valle Papst on 07/03/22.
//

import Foundation
import SpriteKit

class MenuScene: SKScene {
    
    lazy var scenarioImage: SKSpriteNode = {
        var scenario = SKSpriteNode(imageNamed: "cenario")
        return scenario
    }()
    
    lazy var piano: SKSpriteNode = {
        var piano = SKSpriteNode(imageNamed: "piano")
        return piano
    }()
    
    lazy var playButton: SKButtonNode = {
        var bt = SKButtonNode(image: SKSpriteNode(imageNamed: "jogarBotao")) {
            // TODO: levar implementação para a controller
        }
        return bt
    }()
    
    lazy var soundButton: SKButtonNode = {
        var bt = SKButtonNode(image: SKSpriteNode(imageNamed: "somBotao")) {
        }
        return bt
    }()
    
    lazy var musicButton: SKButtonNode = {
        var bt = SKButtonNode(image: SKSpriteNode(imageNamed: "musicaBotao")) {
        }
        return bt
    }()
    
    lazy var gameCenterButton: SKButtonNode = {
        var bt = SKButtonNode(image: SKSpriteNode(imageNamed: "gameCenterBotao")) {
        }
        return bt
    }()
    
    lazy var scoreLabel: SKLabelNode = {
        var lbl = SKLabelNode()
        lbl.numberOfLines = 0
        lbl.fontColor = SKColor.black
        lbl.fontName = "munro"
        lbl.text = "Highscore: 2067"
        return lbl
    }()
    
    lazy var catAction: SKSpriteNode = {
        var cat = SKSpriteNode(imageNamed: "gato0")
        
        let texture: [SKTexture] = [SKTexture(imageNamed: "gato0.png"),
                                    SKTexture(imageNamed: "gato1.png"),
                                    SKTexture(imageNamed: "gato2.png"),
                                    SKTexture(imageNamed: "gato3.png")]
        for t in texture {
            t.filteringMode = .nearest
        }
        
        let idleAnimation = SKAction.animate(with: texture, timePerFrame: 0.25)
        let loop = SKAction.repeatForever(idleAnimation)
        cat.run(loop)
        
        return cat
    }()
    
    lazy var chandelier: SKSpriteNode = {
        var chand = SKSpriteNode(imageNamed: "lustre")
        return chand
    }()
    
    lazy var chair: SKSpriteNode = {
        var chair = SKSpriteNode(imageNamed: "cadeira")
        return chair
    }()
    
    lazy var flyAction: SKSpriteNode = {
        var fly = SKSpriteNode(imageNamed: "mosca")
        
        let texture: [SKTexture] = [SKTexture(imageNamed: "mosca0"),
                                     SKTexture(imageNamed: "mosca1"),
                                     SKTexture(imageNamed: "mosca2"),
                                     SKTexture(imageNamed: "mosca3"),
                                     SKTexture(imageNamed: "mosca4"),
                                     SKTexture(imageNamed: "mosca5")]
        
        for t in texture {
            t.filteringMode = .nearest
        }
        
        let idleANimation = SKAction.animate(with: texture, timePerFrame: 0.08)
        let loop = SKAction.repeatForever(idleANimation)
        fly.run(loop)
        
        return fly
    }()
    
    class func newGameScene() -> MenuScene {
        let scene = MenuScene()
        scene.scaleMode = .resizeFill
        return scene
    }
    
    func setUpScene() {
        self.addChild(scoreLabel)
        self.addChild(musicButton)
        self.addChild(scenarioImage)
        self.addChild(playButton)
        self.addChild(soundButton)
        self.addChild(gameCenterButton)
        self.addChild(piano)
        self.addChild(catAction)
        self.addChild(chandelier)
        self.addChild(chair)
        self.addChild(flyAction)
    }
    
    override func didMove(to view: SKView) {
        self.setUpScene()
    }
    
    override func didChangeSize(_ oldSize: CGSize) {
        setupNodesPosition()
        setupNodesSize()
    }
    
    private func setupNodesSize() {
        scenarioImage.size.width = self.size.width
        scenarioImage.size.height = self.size.height
        
        playButton.setScale(self.size.height/2300)
        musicButton.setScale(self.size.height/2300)
        soundButton.setScale(self.size.height/2300)
        gameCenterButton.setScale(self.size.height/2300)
        piano.setScale(self.size.height/2300)
        catAction.setScale(self.size.height/2500)
        chandelier.setScale(self.size.height/2300)
        chair.setScale(self.size.height/2300)
        flyAction.setScale(self.size.height/2800)
    }
    
    private func setupNodesPosition() {
        scenarioImage.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        scenarioImage.zPosition = 0
        
        soundButton.position = CGPoint(x: self.size.width/2, y: self.size.height/3.5)
        soundButton.zPosition = 1
        
        scoreLabel.position = CGPoint(x: self.size.width/2, y: self.size.height/2.5)
        scoreLabel.zPosition = 1
        scoreLabel.fontSize = self.size.height/15
        
        musicButton.position = CGPoint(x: soundButton.position.x + self.size.width/9.5, y: self.size.height/3.5)
        musicButton.zPosition = 1
        
        gameCenterButton.position = CGPoint(x: soundButton.position.x - self.size.width/9.5, y: self.size.height/3.5)
        gameCenterButton.zPosition = 1
        
        playButton.position = CGPoint(x: self.size.width/2, y: self.size.height/1.6)
        playButton.zPosition = 1
        
        piano.position = CGPoint(x: self.size.width/8.5, y: self.size.height/3.5)
        piano.zPosition = 1
        
        catAction.position = CGPoint(x: self.size.width/6, y: self.size.height/1.4)
        catAction.zPosition = 2
        
        chandelier.position = CGPoint(x: self.size.width/1.42, y: self.size.height/1.19)
        chandelier.zPosition = 1
        
        chair.position = CGPoint(x: self.size.width/1.215, y: self.size.height/6.5)
        chair.zPosition = 1
        
        flyAction.position = CGPoint(x: self.size.width/1.215, y: self.size.height/2.28)
        flyAction.zPosition = 1
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}

extension MenuScene: MenuLogicDelegate {
    func goToGameCenter() {
    }
    func playGame() {
        let scene = GameScene.newGameScene()
        self.view?.presentScene(scene)
    }
    func toggleSound() {
    }
    func toggleMusic() {
    }
}



















