//
//  PauseMenu.swift
//  FlyGame
//
//  Created by Caroline Taus on 14/03/22.
//

import SpriteKit

class PauseMenu: SKNode {
    
    let buttonsPause = UITapGestureRecognizer()
    
    var buttonsContainer: SKShapeNode = SKShapeNode(
        rectOf: .screenSize(widthMultiplier: 0.5, heighMultiplier: 0.8),
        cornerRadius: 20)
    
    var bg: SKSpriteNode = SKSpriteNode(imageNamed: "cenario")
    let screenSize: CGSize = .screenSize()
    weak var gameDelegate: GameLogicDelegate?
    
    lazy var retryButton: SKButtonNode = {
        let but = SKButtonNode(image: .restart) {
        }
        return but
    }()
    
    lazy var homeButton: SKButtonNode = {
        let but = SKButtonNode(image: .menu) {
            self.gameDelegate?.goToHome()
        }
        return but
    }()
    
    lazy var resumeButton: SKButtonNode = {
        let but = SKButtonNode(image: .resume) {
            self.gameDelegate?.resumeGame()
        }
        return but
    }()
    
    lazy var soundButton: SKButtonNode = {
        let but = SKButtonNode(image: .soundOn) {
            self.gameDelegate?.soundAction()
        }
        return but
    }()
    
    lazy var musicButton: SKButtonNode = {
        let but = SKButtonNode(image: .musicOn) {
            self.gameDelegate?.musicAction()
        }
        return but
    }()
    
    override var isUserInteractionEnabled: Bool {
        get {return true}
        set {}
    }
    
    override init() {
        super.init()
        addChild(bg)
        addChild(buttonsContainer)
        buttonsContainer.addChild(homeButton)
        buttonsContainer.addChild(retryButton)
        buttonsContainer.addChild(soundButton)
        buttonsContainer.addChild(musicButton)
        buttonsContainer.addChild(resumeButton)
        
        bg.size = screenSize
        
        homeButton.setScale(bg.size.width * 0.00023)
        retryButton.setScale(bg.size.width * 0.00023)
        soundButton.setScale(bg.size.width * 0.00023)
        musicButton.setScale(bg.size.width * 0.00023)
        resumeButton.setScale(bg.size.width * 0.002)
        
#if os(iOS)
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            resumeButton.setScale(bg.size.width * 0.003)
        default:
            break
        }
#endif
                
        buttonsContainer.lineWidth = 0
        setPositions()
    }
    
    required init?(coder aDecoder: NSCoder) {fatalError("init(coder:) has not been implemented")}
    
    func setPositions() {
        resumeButton.zPosition = 4
        resumeButton.position = CGPoint(x: 0, y: buttonsContainer.frame.size.height * 0.15)
        
        bg.zPosition = 3
        
        homeButton.zPosition = 4
        homeButton.position = CGPoint(x: -buttonsContainer.frame.size.width/3,
                                      y: -resumeButton.position.y*1.4)
        
        retryButton.zPosition = 4
        retryButton.position = CGPoint(x: -buttonsContainer.frame.size.width/9,
                                       y: -resumeButton.position.y*1.4)
        
        soundButton.zPosition = 4
        soundButton.position = CGPoint(x: buttonsContainer.frame.size.width/9,
                                       y: -resumeButton.position.y*1.4)
        
        musicButton.zPosition = 4
        musicButton.position = CGPoint(x: buttonsContainer.frame.size.width/3,
                                       y: -resumeButton.position.y*1.4)
        
    }
}
