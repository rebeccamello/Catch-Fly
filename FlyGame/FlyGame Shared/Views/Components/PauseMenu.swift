//
//  PauseMenu.swift
//  FlyGame
//
//  Created by Caroline Taus on 14/03/22.
//

import Foundation
import SpriteKit

class PauseMenu: SKNode {
    
    //var bg: SKSpriteNode = SKSpriteNode(color: .black, size: .screenSize())
    var buttonsContainer: SKShapeNode = SKShapeNode(rectOf: .screenSize(widthMultiplier: 0.5, heighMultiplier: 0.8), cornerRadius: 20)
    lazy var retryButton: SKButtonNode = {
        let but = SKButtonNode(image: SKSpriteNode(imageNamed: "retryButton")) {
            
        }
        return but
    }()
    lazy var homeButton: SKButtonNode = {
        let but = SKButtonNode(image: SKSpriteNode(imageNamed: "homeButton")) {
            
        }
        return but
    }()
    lazy var resumeButton: SKButtonNode = {
        let but = SKButtonNode(image: SKSpriteNode(imageNamed: "continuarBotao")) {
            
        }
        return but
    }()
    lazy var soundButton: SKButtonNode = {
        let but = SKButtonNode(image: SKSpriteNode(imageNamed: "soundButton")) {
        }
        return but
    }()
    
    lazy var musicButton: SKButtonNode = {
        let but = SKButtonNode(image: SKSpriteNode(imageNamed: "musicButton")) {
        }
        return but
    }()
    
    
    
    
    override init() {
       
        super.init()
        //addChild(bg)
        addChild(buttonsContainer)
        buttonsContainer.addChild(homeButton)
        buttonsContainer.addChild(retryButton)
        buttonsContainer.addChild(soundButton)
        buttonsContainer.addChild(musicButton)
        buttonsContainer.addChild(resumeButton)
        
        homeButton.setScale(0.1)
        retryButton.setScale(0.1)
        soundButton.setScale(0.1)
        musicButton.setScale(0.1)
        resumeButton.setScale(0.1)
        
//        bg.zPosition = 950
//        buttonsContainer.zPosition = 951
//        returnButton.zPosition = 952
//        exitButton.zPosition = 952
//        bg.alpha = 0.45
//        buttonsContainer.fillColor = .pauseMenuGray
//        buttonsContainer.lineWidth = 0
        resumeButton.position = CGPoint(x: 200, y: 200)
        
        
        
     
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isUserInteractionEnabled: Bool {
        set {
            // ignore
        }
        get {
            return true
        }
    }
   
    
    
   
    
}
