//
//  SKButtonNode.swift
//  FlyGame
//
//  Created by Gabriele Namie on 11/03/22.
//

import SpriteKit


class SKButtonNode: SKNode {
    
    var image: SKSpriteNode
    var action: (() -> Void)
    var isFocusable = true
    
    init(image: Buttons, action: @escaping () -> Void) {
        let texture = SKTexture(imageNamed: image.description)
        texture.filteringMode = .nearest
        
        self.image = SKSpriteNode(texture: texture)
        self.action = action
        
        super.init()
        
        #if os(tvOS)
        self.alpha = 0.75
        #endif
        
        self.isUserInteractionEnabled = true
        self.addChild(self.image)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var canBecomeFocused: Bool {
        return isFocusable
    }
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        
        if context.previouslyFocusedItem === self {
            self.setScale(self.xScale/1.1)
            self.setScale(self.yScale/1.1)
            self.alpha = 0.75
        }
        
        if context.nextFocusedItem === self {
            self.setScale(self.xScale*1.1)
            self.setScale(self.yScale*1.1)
            self.alpha = 1
        }
    }
    #if os(tvOS)
    override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        self.action()
    }
    #endif
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        AudioService.shared.soundManager(with: .button, soundAction: .play)
        self.action()
    }
    
    
    public func updateImage(with image: Buttons) -> Void {
        self.image.texture = SKTexture(imageNamed: image.description)
    }
}
