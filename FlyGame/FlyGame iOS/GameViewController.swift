//
//  GameViewController.swift
//  FlyGame iOS
//
//  Created by Nathalia do Valle Papst on 07/03/22.
//

import UIKit
import SpriteKit
import GameplayKit
import GameKit

class GameViewController: UIViewController {
    let scene = MenuScene.newGameScene()
    
    let gameCenterDelegate = GameCenterDelegate()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gameCenterManagar = GameCenterService()
                
        gameCenterManagar.autenticateUser() {result in
            switch result {
            case .success(let vc):
                
                if let vc = vc {
                    self.present(vc, animated: true)
                }
            
            case .failure(let error):
                print("Erro: \(error.description)")
            }
        }
        
        
        self.scene.gameCenterButton.action = {
            if let vc = gameCenterManagar.showGameCenterPage(.leaderboards) {
                vc.gameCenterDelegate = self.gameCenterDelegate
                self.present(vc, animated: true)
            }
        }
    }
    
    override func loadView() {
        let skView = SKView()
        skView.presentScene(scene)
        
        skView.ignoresSiblingOrder = true
//        skView.showsFPS = true
//        skView.showsNodeCount = true
        
        self.view = skView
    }
    override var preferredScreenEdgesDeferringSystemGestures: UIRectEdge {
        return UIRectEdge.bottom
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
