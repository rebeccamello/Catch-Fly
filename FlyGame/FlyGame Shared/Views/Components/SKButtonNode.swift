//
//  SKButtonNode.swift
//  FlyGame
//
//  Created by Gabriele Namie on 11/03/22.
//

import Foundation
import SpriteKit

class SKButtonNode: SKNode {
    
  var image: SKSpriteNode
  var action: (() -> Void) // TODO: Adicionar foco nos botões
    
  init(image: SKSpriteNode, action: @escaping () -> Void) {
    self.image = image
    self.action = action
    super.init()
    self.isUserInteractionEnabled = true
    self.addChild(self.image)
  }
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
    
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.action()
  }
}
