//
//  MenuScene.swift
//  FlyGame
//
//  Created by Nathalia do Valle Papst on 07/03/22.
//

import Foundation
import SpriteKit

class MenuScene: SKScene {
    let tapGeneralSelection = UITapGestureRecognizer()
    
    lazy var menuLogic: MenuSceneController = {
        let m = MenuSceneController()
        m.menuDelegate = self
        return m
    }()
    
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
        var bt = SKButtonNode(image: .play) {
            self.playGame()
        }
        bt.image.texture?.filteringMode = .nearest
        return bt
    }()
    
    lazy var soundButton: SKButtonNode = {
        var bt = SKButtonNode(image: .soundOn) {
            self.menuLogic.toggleSound()
        }
        bt.image.texture?.filteringMode = .nearest
        return bt
    }()
    
    lazy var musicButton: SKButtonNode = {
        var bt = SKButtonNode(image: .musicOn) {
            self.menuLogic.toggleMusic()
        }
        bt.image.texture?.filteringMode = .nearest
        return bt
    }()
    
    lazy var gameCenterButton: SKButtonNode = {
        var bt = SKButtonNode(image: .gameCenter) {
        }
        bt.image.texture?.filteringMode = .nearest
        return bt
    }()
    
    lazy var scoreLabel: SKLabelNode = {
        var lbl = SKLabelNode()
        lbl.numberOfLines = 0
        lbl.fontColor = SKColor.black
        lbl.fontName = "munro"
        lbl.text = String(format: NSLocalizedString(.highscore), playerHighscore)
        return lbl
    }()
    
    lazy var playerHighscore: String = {
        //TODO: Pegar valor do gameCenter
        var score = String(2)
        return score
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
        
        #if os(tvOS)
        addTapGestureRecognizer()
        #endif
        
        
        // Verifica se é a primeira vez que está entrando no app
        if !UserDefaults.standard.bool(forKey: "firstTimeOpenApp") {
            AudioService.shared.toggleSound(with: self.soundButton)
            AudioService.shared.toggleMusic(with: self.musicButton)
            
            UserDefaults.standard.set(true, forKey: "firstTimeOpenApp")
        }
        
        // Verifica se os áudios já estavam inativos
        if !AudioService.shared.getUserDefaultsStatus(with: .sound) {
            self.soundButton.updateImage(with: .soundOff)
        }
        
        if !AudioService.shared.getUserDefaultsStatus(with: .music) {
            self.musicButton.updateImage(with: .musicOff)
        } else {
            AudioService.shared.soundManager(with: .backgroundMusic, soundAction: .play, .loop)
        }
    }
    
    override func didChangeSize(_ oldSize: CGSize) {
        setupNodesPosition()
        setupNodesSize()
    }

    func playGame() {
        //TODO: IF FIRST RUN VAI PRO TUTORIAL
//        let scene = TutorialScene.newGameScene()
        let scene = GameScene.newGameScene()
        scene.isGameStarted = true
        self.view?.presentScene(scene)
        
#if os(tvOS)
        scene.run(SKAction.wait(forDuration: 0.02)) {
        scene.view?.window?.rootViewController?.setNeedsFocusUpdate()
        scene.view?.window?.rootViewController?.updateFocusIfNeeded()
        }
#endif
    }
    
    private func setupNodesSize() {
        scenarioImage.size.width = self.size.width
        scenarioImage.size.height = self.size.height
        
        playButton.setScale(self.size.height/250)
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
        
        chandelier.position = CGPoint(x: self.size.width/1.3, y: self.size.height/1.19)
        chandelier.zPosition = 1
        
        chair.position = CGPoint(x: self.size.width/1.215, y: self.size.height/6.5)
        chair.zPosition = 1
        
        flyAction.position = CGPoint(x: self.size.width/1.215, y: self.size.height/2.28)
        flyAction.zPosition = 1
    }
    
    override func update(_ currentTime: TimeInterval) {
    }

#if os(tvOS)
    func addTapGestureRecognizer(){
        tapGeneralSelection.addTarget(self, action: #selector(clicked))
        self.view?.addGestureRecognizer(tapGeneralSelection)
    }
    
    @objc func clicked() {
        
        if playButton.isFocused {
            playGame()
            
        } else if soundButton.isFocused {
            self.menuLogic.toggleSound()
            
        } else if musicButton.isFocused {
            self.menuLogic.toggleMusic()
            
        } else if gameCenterButton.isFocused {
            
        }
    }
#endif
}

extension MenuScene: MenuLogicDelegate {
    func goToGameCenter() {
    }
    
    func getSoundButton() -> SKButtonNode {
        return soundButton
    }
    
    func getMusicButton() -> SKButtonNode {
        return musicButton
    }
}

#if os(tvOS)
extension MenuScene {
    override var preferredFocusEnvironments: [UIFocusEnvironment] {
        return [playButton]
    }
}
#endif


















