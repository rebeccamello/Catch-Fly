//
//  LoadingView.swift
//  FlyGame
//
//  Created by Rebecca Mello on 13/04/22.
//

import Foundation
import SpriteKit

class LoadingView: SKNode {
    let buttonsPause = UITapGestureRecognizer()
    
    var buttonsContainer: SKShapeNode = SKShapeNode(
        rectOf: .screenSize(widthMultiplier: 0.5, heighMultiplier: 0.8),
        cornerRadius: 20)
    
    var bg: SKSpriteNode = SKSpriteNode(imageNamed: "cenario")
    let screenSize: CGSize = .screenSize()
    weak var gameDelegate: GameLogicDelegate?
    
    lazy var loadingButton: SKButtonNode = {
        let but = SKButtonNode(image: .revive) {
            print("game over")
        }
        return but
    }()
    
    override init() {
        super.init()
        addChild(bg)
        addChild(buttonsContainer)
        buttonsContainer.addChild(loadingButton)
        
        bg.size = screenSize
        
        loadingButton.setScale(bg.size.width * 0.001)
        
        buttonsContainer.lineWidth = 0
        setPositions()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setPositions() {
        bg.zPosition = 3
        
        loadingButton.position = CGPoint(x: 0, y: 0)
        loadingButton.zPosition = 4
    }
}
