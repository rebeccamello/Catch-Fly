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
    
    let scene = MenuScene.newGameScene()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        
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

}
