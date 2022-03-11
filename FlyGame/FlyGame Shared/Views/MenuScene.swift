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
        var scenario = SKSpriteNode()
        scenario = SKSpriteNode(imageNamed: "cenario")
        return scenario
    }()
    
    lazy var pianoImage: SKSpriteNode = {
        var piano = SKSpriteNode(imageNamed: "Piano")
        return piano
    }()
    
    lazy var playButton: SKButtonNode = {
        var bt = SKButtonNode(image: SKSpriteNode(imageNamed: "JogarBotao")) {
            // TODO: levar implementação para a controller
            let scene = GameScene.newGameScene()
            self.view?.presentScene(scene)
        }
        return bt
    }()
    
    lazy var soundButton: SKButtonNode = {
        var bt = SKButtonNode(image: SKSpriteNode(imageNamed: "SomBotao")) {
        }
        return bt
    }()
    
    lazy var musicButton: SKButtonNode = {
        var bt = SKButtonNode(image: SKSpriteNode(imageNamed: "MusicaBotao")) {
        }
        return bt
    }()
    
    lazy var gameCenterButton: SKButtonNode = {
        var bt = SKButtonNode(image: SKSpriteNode(imageNamed: "GameCenterBotao")) {
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
        self.addChild(pianoImage)
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
        
        playButton.setScale(self.size.height/410)
        musicButton.setScale(self.size.height/460.6)
        soundButton.setScale(self.size.height/460.6)
        gameCenterButton.setScale(self.size.height/460.6)
        pianoImage.setScale(self.size.height/400)
    }
    
    private func setupNodesPosition() {
        scenarioImage.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        scenarioImage.zPosition = 0
        
        soundButton.position = CGPoint(x: self.size.width/2, y: self.size.height/3.5)
<<<<<<< Updated upstream
        soundButton.zPosition = 1
        
        scoreLabel.position = CGPoint(x: self.size.width/2, y: self.size.height/2.5)
        scoreLabel.zPosition = 1
        
=======
        soundButton.zPosition = 2
        scoreLabel.position = CGPoint(x: self.size.width/2, y: self.size.height/2.5)
        scoreLabel.zPosition = 2
>>>>>>> Stashed changes
        scoreLabel.fontSize = self.size.height/15
        musicButton.position = CGPoint(x: soundButton.position.x + self.size.width/9.5, y: self.size.height/3.5)
        musicButton.zPosition = 2
        gameCenterButton.position = CGPoint(x: soundButton.position.x - self.size.width/9.5, y: self.size.height/3.5)
        gameCenterButton.zPosition = 2
        playButton.position = CGPoint(x: self.size.width/2, y: self.size.height/1.6)
        playButton.zPosition = 2
        pianoImage.position = CGPoint(x: self.size.width/8.5, y: self.size.height/3)
        pianoImage.zPosition = 1
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



















