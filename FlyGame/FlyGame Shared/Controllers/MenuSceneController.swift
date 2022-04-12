//
//  MenuSceneController.swift
//  FlyGame
//
//  Created by Nathalia do Valle Papst on 07/03/22.
//

import SpriteKit

class MenuSceneController {
    
    /* MARK: - Atributos */
    var menuDelegate: MenuLogicDelegate?
    
    /* MARK: - Métodos */
    
    func toggleSound() {
        if let node = menuDelegate?.getButtons()[0] {
            AudioService.shared.toggleSound(with: node)
        }
    }
    
    func toggleMusic() {
        if let node = menuDelegate?.getButtons()[1] {
            AudioService.shared.toggleMusic(with: node)
        }
    }
    
    func audioVerification() {
        
        // Primeira vez que está entrando no app
        if !UserDefaults.getBoolValue(with: .firstTimeOnApp) {
            
            if let soundButton = menuDelegate?.getButtons()[0] {
                AudioService.shared.toggleSound(with: soundButton)
            } else { return }
            
            if let musicButton = menuDelegate?.getButtons()[1] {
                AudioService.shared.toggleMusic(with: musicButton)
            } else { return }
            
            UserDefaults.updateValue(in: .firstTimeOnApp, with: true)
        }
        
        // Verifica se os áudios já estavam inativos
        if !AudioService.shared.getUserDefaultsStatus(with: .sound) {
            menuDelegate?.getButtons()[0].updateImage(with: .soundOff)
        }
        
        if !AudioService.shared.getUserDefaultsStatus(with: .music) {
            menuDelegate?.getButtons()[1].updateImage(with: .musicOff)
        } else {
            AudioService.shared.soundManager(with: .backgroundMusic, soundAction: .play, .loop)
        }
    }
    
    func addTapGestureRecognizer() -> UITapGestureRecognizer {
        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: #selector(clicked))
        return tap
    }
    
    @objc func clicked() {
        if let delegate = menuDelegate {
            let buttons = delegate.getButtons()
            if buttons[0].isFocused {           // Som
                self.toggleSound()
                
            } else if buttons[1].isFocused {    // Música
                self.toggleMusic()
                
            } else if buttons[2].isFocused {    // Game Center
                delegate.goToGameCenter()
                
            } else if buttons[3].isFocused {    // Jogo
                delegate.goToGameScene()
            }
        }
    }
    
    func playGame() {
        if let delegate = self.menuDelegate {
            var scene: SKScene
            
            switch delegate.getTutorialStatus() {
            case true:
                scene = TutorialScene.newGameScene()
            case false:
                let newScene = GameScene.newGameScene()
                newScene.gameLogic.isGameStarted = true
                
                scene = newScene
            }
                        
            delegate.presentScene(scene: scene)
        }
    }
}
