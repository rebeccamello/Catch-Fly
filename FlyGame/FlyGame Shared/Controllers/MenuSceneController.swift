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
        if let node = menuDelegate?.getSoundButton() {
            self.audioService.toggleSound(with: node)
        }
    }
    func toggleMusic() {
        if let node = menuDelegate?.getMusicButton() {
            self.audioService.toggleMusic(with: node)
        }
    }
    
    func audioVerification() {
        
        // Verifica se é a primeira vez que está entrando no app
        if !UserDefaults.standard.bool(forKey: "firstTimeOpenApp") {
            
            if let soundButton = menuDelegate?.getSoundButton() {
                AudioService.shared.toggleSound(with: soundButton)
            } else { return }
            
            if let musicButton = menuDelegate?.getMusicButton() {
                AudioService.shared.toggleMusic(with: musicButton)
            } else { return }
            
            UserDefaults.standard.set(true, forKey: "firstTimeOpenApp")
        }
        
        // Verifica se os áudios já estavam inativos
        if !AudioService.shared.getUserDefaultsStatus(with: .sound) {
            menuDelegate?.getSoundButton().updateImage(with: .soundOff)
        }
        
        if !AudioService.shared.getUserDefaultsStatus(with: .music) {
            menuDelegate?.getMusicButton().updateImage(with: .musicOff)
        } else {
            AudioService.shared.soundManager(with: .backgroundMusic, soundAction: .play, .loop)
        }
    }
    
    func addTapGestureRecognizer() -> UITapGestureRecognizer {
        tapGeneralSelection.addTarget(self, action: #selector(clicked))
        return tapGeneralSelection
    }
    
    @objc func clicked() {
        
        if ((menuDelegate?.getPlayButton().isFocused) == true) {
            menuDelegate?.playGame()
            
        } else if (menuDelegate?.getSoundButton().isFocused) == true {
            toggleSound()
            
        } else if (menuDelegate?.getMusicButton().isFocused) == true {
            toggleMusic()
            
        } else if (menuDelegate?.getGameCenterButton().isFocused) == true {
            menuDelegate?.goToGameCenter()
        }
    }
}
