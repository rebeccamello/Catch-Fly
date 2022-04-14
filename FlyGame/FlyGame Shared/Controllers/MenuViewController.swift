//
//  MenuViewController.swift
//  FlyGame
//
//  Created by Gui Reis on 24/03/22.
//

import SpriteKit

class MenuViewController: UIViewController {
    
    /* MARK: - Ciclo de Vida */
    
    override func loadView() {
        let scene = MenuScene.newGameScene()
        
        let skView = SKView()
        skView.ignoresSiblingOrder = true
        skView.presentScene(scene)
        
        skView.showsPhysics = true
        skView.showsFPS = true
        skView.showsNodeCount = true
        self.view = skView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GameCenterService.shared.setController(self)
        self.gameCenterAutentication()
    }
    
    func gameCenterAutentication() {
        // Fazendo a autenticação com o Game Center
        GameCenterService.shared.autenticateUser {vc, score, error in
            if error != nil {
                return
            }
            
            if let vc = vc {
                self.present(vc, animated: true)
                return
            }
            
            if let score = score {
                guard let scene = (self.view as? SKView)?.scene as? MenuScene else {return}
                scene.setScore(with: score)
            }
        }
    }
}
