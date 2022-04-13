//
//  AdMenu.swift
//  FlyGame
//
//  Created by Rebecca Mello on 13/04/22.
//

import Foundation
import SpriteKit

class AdMenu: SKNode {
    
    let buttonsPause = UITapGestureRecognizer()
    
    var buttonsContainer: SKShapeNode = SKShapeNode(
        rectOf: .screenSize(widthMultiplier: 0.5, heighMultiplier: 0.8),
        cornerRadius: 20)
    
    var bg: SKSpriteNode = SKSpriteNode(imageNamed: "cenario")
    let screenSize: CGSize = .screenSize()
    weak var gameDelegate: GameLogicDelegate?
    
    lazy var adButton: SKButtonNode = {
        let but = SKButtonNode(image: .revive) {
            self.gameDelegate?.callLoadingView()
            self.gameDelegate?.showAds()
        }
        return but
    }()
    
    lazy var gameOverButton: SKButtonNode = {
        let but = SKButtonNode(image: .giveUp) {
            self.gameDelegate?.goToGameOverScene()
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
        buttonsContainer.addChild(adButton)
        buttonsContainer.addChild(gameOverButton)
        
        bg.size = screenSize
        
        adButton.setScale(bg.size.width * 0.0022)
        gameOverButton.setScale(bg.size.width * 0.0022)
        
        buttonsContainer.lineWidth = 0
        setPositions()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setPositions() {
        bg.zPosition = 3
        
        adButton.position = CGPoint(x: 0, y: buttonsContainer.frame.size.height * 0.2)
        adButton.zPosition = 4
        
        gameOverButton.position = CGPoint(x: 0, y: -buttonsContainer.frame.size.height * 0.2)
        gameOverButton.zPosition = 4
    }
}
