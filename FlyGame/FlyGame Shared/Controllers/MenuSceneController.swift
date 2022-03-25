//
//  MenuSceneController.swift
//  FlyGame
//
//  Created by Nathalia do Valle Papst on 07/03/22.
//

class MenuSceneController {
    var menuDelegate: MenuLogicDelegate?
    var audioService = AudioService.shared
    
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
}
