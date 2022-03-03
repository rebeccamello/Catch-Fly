//
//  GameScene.swift
//  GameStructure Shared
//
//  Created by Rebecca Mello on 03/03/22.
//

import SpriteKit

class GameScene: SKScene {
    
    class func newGameScene() -> GameScene {
        // instancia
        let scene = GameScene()
        
        // Set the scale mode to scale to fit the window
        scene.scaleMode = .resizeFill
        GameController.shared.setScene(scene: scene)
        
        return scene
    }
    
    func setUpScene() {
        GameController.shared.renderer.setUpScene()
    }
    
    override func didMove(to view: SKView) {
        self.setUpScene()
    }
    
    override func didChangeSize(_ oldSize: CGSize) {
        super.didChangeSize(oldSize)
        self.setUpScene()
    }
    
    override func update(_ currentTime: TimeInterval) {
        GameController.shared.update(currentTime)
    }
}

#if os(iOS) || os(tvOS)
// Touch-based event handling
extension GameScene {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        GameController.shared.movePlayerUp()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    
    }
}
#endif

#if os(OSX)
// Mouse-based event handling
extension GameScene {

    override func mouseDown(with event: NSEvent) {
        GameController.shared.movePlayerUp()
    }
    
    override func mouseDragged(with event: NSEvent) {
        
    }
    
    override func mouseUp(with event: NSEvent) {
        
    }

}
#endif

