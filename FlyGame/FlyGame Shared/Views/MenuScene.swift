//
//  MenuScene.swift
//  FlyGame
//
//  Created by Nathalia do Valle Papst on 07/03/22.
//

import SpriteKit

class MenuScene: SKScene {
    var hideTutorial: Bool = false
    
    lazy var menuLogic: MenuSceneController = {
        let m = MenuSceneController()
        m.menuDelegate = self
        return m
    }()
    
    lazy var scenarioImage: SKSpriteNode = SKSpriteNode(imageNamed: "cenario")
    
    lazy var piano: SKSpriteNode = SKSpriteNode(imageNamed: "piano")
    
    lazy var playButton = SKButtonNode(image: .play) {
        self.goToGameScene()
    }
    
    lazy var soundButton = SKButtonNode(image: .soundOn) {
        self.menuLogic.toggleSound()
    }
        
    lazy var musicButton = SKButtonNode(image: .musicOn) {
        self.menuLogic.toggleMusic()
    }
        
    lazy var gameCenterButton = SKButtonNode(image: .gameCenter) {
        self.goToGameCenter()
    }
    
    lazy var scoreLabel: SKLabelNode = {
        var lbl = SKLabelNode()
        lbl.numberOfLines = 0
        lbl.fontColor = SKColor.black
        lbl.fontName = "munro"
        lbl.text = "highscore".localized() + "\(UserDefaults.getIntValue(with: .highScore))"
        return lbl
    }()
    
    lazy var catAction: SKSpriteNode = {
        var cat = SKSpriteNode(imageNamed: "gato0")
        cat.texture?.filteringMode = .nearest
        
        let frames: [SKTexture] = createTexture("GatoHome")
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
        
        let frames: [SKTexture] = createTexture("Mosca")
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
    
    #if os(tvOS)
    override var preferredFocusEnvironments: [UIFocusEnvironment] {
        return [playButton]
    }
    #endif
    
    /* MARK: - Ciclo de Vida */
    override func didMove(to view: SKView) {
        self.setUpScene()
        
        #if os(tvOS)
        self.presentGesture()
        #endif
        
        menuLogic.audioVerification()
    }
    
    override func didChangeSize(_ oldSize: CGSize) {
        self.setupNodesPosition()
        self.setupNodesSize()
    }
    
    /* MARK: - Métodos */
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
    
    func createTexture(_ name: String) -> [SKTexture] {
        let textureAtlas = SKTextureAtlas(named: name)
        var frames = [SKTexture]()
        for i in 1...textureAtlas.textureNames.count - 1 {
            frames.append(textureAtlas.textureNamed(textureAtlas.textureNames[i]))
        }
        return frames
    }
    
    /// Definindo o tamanho dos Nodes
    private func setupNodesSize() {
        scenarioImage.size.width = self.size.width
        scenarioImage.size.height = self.size.height
        
        // Botões
        playButton.setScale(self.size.height/250)
        musicButton.setScale(self.size.height/2300)
        soundButton.setScale(self.size.height/2300)
        gameCenterButton.setScale(self.size.height/2300)
        
        // Fundo
        piano.setScale(self.size.height/300)
        chandelier.setScale(self.size.height/300)
        chair.setScale(self.size.height/300)
        
        catAction.setScale(self.size.height/700)
        flyAction.setScale(self.size.height/2800)
        
        #if os(iOS)
        if UIDevice.current.userInterfaceIdiom == .pad {    // iPad
            // Botões
            musicButton.setScale(self.size.height/3000)
            soundButton.setScale(self.size.height/3000)
            gameCenterButton.setScale(self.size.height/3000)
            
            // Fundo
            piano.setScale(self.size.height/350)
            chandelier.setScale(self.size.height/350)
            chair.setScale(self.size.height/350)
            
            catAction.setScale(self.size.height/1000)
            flyAction.setScale(self.size.height/3150)
        }
        #endif
    }
    
    /// Posicionando os nodes na tela
    private func setupNodesPosition() {
        let butXPosition = self.size.width/2
        
        // Label
        scoreLabel.setPositions(x: butXPosition, y: self.size.height/2.5, z: 1)
        scoreLabel.fontSize = self.size.height/15
        
        // Botões
        soundButton.setPositions(x: butXPosition, y: self.size.height/3.5, z: 1)
        musicButton.setPositions(x: butXPosition + self.size.width/9.5, y: self.size.height/3.5, z: 1)
        gameCenterButton.setPositions(x: butXPosition - self.size.width/9.5, y: self.size.height/3.5, z: 1)
        playButton.setPositions(x: butXPosition, y: self.size.height/1.6, z: 1)
        
        // Fundo
        scenarioImage.setPositions(x: butXPosition, y: self.size.height/2, z: 0)
        
        piano.setPositions(x: self.size.width/8.5, y: self.size.height/3.5, z: 1)
        chandelier.setPositions(x: self.size.width/1.3, y: self.size.height/1.19, z: 1)
        chair.setPositions(x: self.size.width/1.215, y: self.size.height/6.5, z: 1)
        
        catAction.setPositions(x: self.size.width/6, y: self.size.height/1.4, z: 2)
        flyAction.setPositions(x: self.size.width/1.215, y: self.size.height/2.28, z: 1)
        
        #if os(iOS)
        if UIDevice.current.userInterfaceIdiom == .pad {    // iPad
            chandelier.position.y = self.size.height/1.13
            chair.position.y = self.size.height/7.5
            
            catAction.position.y = self.size.height/1.55
            flyAction.position.y = self.size.height/2.6
        }
        #endif
    }
    
    func presentGesture() {
        self.view?.addGestureRecognizer(menuLogic.addTapGestureRecognizer())
    }

    public func setScore(with score: Int) {
        self.scoreLabel.text = "highscore".localized() + "\(score)"
    }
}

extension MenuScene: MenuLogicDelegate {
    
    func goToGameCenter() {
        GameCenterService.shared.showGameCenterPage(.default)
    }
    
    func getButtons() -> [SKButtonNode] {
        return [soundButton, musicButton, gameCenterButton, playButton]
    }
    
    func getTutorialStatus() -> Bool {
        return hideTutorial
    }
    
    func presentScene(scene: SKScene) {
        self.view?.presentScene(scene)
    }
    
    func goToGameScene() {
        self.hideTutorial = UserDefaults.getBoolValue(with: .tutorial)
        menuLogic.playGame()
    }
}
