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
        piano.texture?.filteringMode = .nearest
        return piano
    }()
    
    lazy var playButton: SKButtonNode = {
        var bt = SKButtonNode(image: SKSpriteNode(imageNamed: "jogarBotao")) {
            let scene = GameScene.newGameScene()
            scene.isGameStarted = true
            self.view?.presentScene(scene)
        }
        bt.image.texture?.filteringMode = .nearest
        return bt
    }()
    
    lazy var soundButton: SKButtonNode = {
        var bt = SKButtonNode(image: SKSpriteNode(imageNamed: "somBotao")) {
        }
        bt.image.texture?.filteringMode = .nearest
        return bt
    }()
    
    lazy var musicButton: SKButtonNode = {
        var bt = SKButtonNode(image: SKSpriteNode(imageNamed: "musicaBotao")) {
        }
        bt.image.texture?.filteringMode = .nearest
        return bt
    }()
    
    lazy var gameCenterButton: SKButtonNode = {
        var bt = SKButtonNode(image: SKSpriteNode(imageNamed: "gameCenterBotao")) {
        }
        bt.image.texture?.filteringMode = .nearest
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
        cat.texture?.filteringMode = .nearest
        
        let frames:[SKTexture] = createTexture("GatoHome")
        cat.run(SKAction.repeatForever(SKAction.animate(with: frames,
                                                            timePerFrame: TimeInterval(0.2),
                                                            resize: false, restore: true)))
        return cat
    }()
    
    lazy var chandelier: SKSpriteNode = {
        var chand = SKSpriteNode(imageNamed: "lustre")
        chand.texture?.filteringMode = .nearest
        return chand
    }()
    
    lazy var chair: SKSpriteNode = {
        var chair = SKSpriteNode(imageNamed: "cadeira")
        chair.texture?.filteringMode = .nearest
        return chair
    }()
    
    lazy var flyAction: SKSpriteNode = {
        var fly = SKSpriteNode(imageNamed: "mosca")
        
        let frames:[SKTexture] = createTexture("Mosca")
        fly.run(SKAction.repeatForever(SKAction.animate(with: frames,
                                                            timePerFrame: TimeInterval(0.2),
                                                            resize: false, restore: true)))
        
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
        piano.setScale(self.size.height/300)
        catAction.setScale(self.size.height/700)
        chandelier.setScale(self.size.height/300)
        chair.setScale(self.size.height/300)
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
    }
    func toggleSound() {
    }
    func toggleMusic() {
    }
}



















