//
//  MenuSceneController.swift
//  FlyGame
//
//  Created by Nathalia do Valle Papst on 07/03/22.
//

import SpriteKit
import UIKit

class MenuSceneController {
    var menuDelegate: MenuLogicDelegate?
    var audioService = AudioService.shared
    let tapGeneralSelection = UITapGestureRecognizer()
    
    func toggleSound() {
        if let node = menuDelegate?.getButtons()[0] {
            self.audioService.toggleSound(with: node)
        }
    }
    func toggleMusic() {
        if let node = menuDelegate?.getButtons()[1] {
            self.audioService.toggleMusic(with: node)
        }
    }
    
    func audioVerification() {
        
        // Verifica se é a primeira vez que está entrando no app
        if !UserDefaults.standard.bool(forKey: "firstTimeOpenApp") {
            
            if let soundButton = menuDelegate?.getButtons()[0] {
                AudioService.shared.toggleSound(with: soundButton)
            } else { return }
            
            if let musicButton = menuDelegate?.getButtons()[1] {
                AudioService.shared.toggleMusic(with: musicButton)
            } else { return }
            
            UserDefaults.standard.set(true, forKey: "firstTimeOpenApp")
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
        tapGeneralSelection.addTarget(self, action: #selector(clicked))
        return tapGeneralSelection
    }
    
    @objc func clicked() {
        
        if ((menuDelegate?.getButtons()[3].isFocused) == true) {
            playGame()
            
        } else if (menuDelegate?.getButtons()[0].isFocused) == true {
            toggleSound()
            
        } else if (menuDelegate?.getButtons()[1].isFocused) == true {
            toggleMusic()
            
        } else if (menuDelegate?.getButtons()[2].isFocused) == true {
            menuDelegate?.goToGameCenter()
        }
    }
    
    func playGame() {
        if menuDelegate?.getTutorialStatus() == false {
            let scene = TutorialScene.newGameScene()
            menuDelegate?.presentScene(scene: scene)
        } else {
            let scene = GameScene.newGameScene()
            scene.gameLogic.isGameStarted = true
            menuDelegate?.presentScene(scene: scene)
            
        }
    }
}
