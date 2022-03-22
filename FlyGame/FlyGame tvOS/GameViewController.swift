//
//  GameViewController.swift
//  FlyGame tvOS
//
//  Created by Nathalia do Valle Papst on 07/03/22.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        let scene = MenuScene.newGameScene()
        
        let skView = SKView()
        skView.presentScene(scene)
        
        skView.ignoresSiblingOrder = true
//        skView.showsFPS = true
//        skView.showsNodeCount = true
        
        self.view = skView
    }
}

extension GameViewController {

      override var preferredFocusEnvironments: [UIFocusEnvironment] {
           if let scene = (view as? SKView)?.scene {
               return [scene]
           }
          
           return []
      }
 }
