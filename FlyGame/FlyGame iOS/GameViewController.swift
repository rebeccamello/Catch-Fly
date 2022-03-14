//
//  GameViewController.swift
//  FlyGame iOS
//
//  Created by Nathalia do Valle Papst on 07/03/22.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    let scene = MenuScene.newGameScene()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gameCenterManagar = GameCenterService(with: self)
        
        gameCenterManagar.autenticateUser() {result in
            switch result {
            case .success(_):
                
                gameCenterManagar.getHighScore() {result in
                    switch result {
                    case .success(let score):
                        self.scene.setScore(with: score)
                        
                    case .failure(let error):
                        print("Erro: \(error.description)")
                    }
                }
                
            case .failure(let error):
                print("Erro: \(error.description)")
            }
        }
    }
    
    override func loadView() {
        let skView = SKView()
        skView.presentScene(scene)
        
        skView.ignoresSiblingOrder = true
        skView.showsFPS = true
        skView.showsNodeCount = true
        
        self.view = skView
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
