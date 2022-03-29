//
//  GameOverController.swift
//  FlyGame
//
//  Created by Nathalia do Valle Papst on 07/03/22.
//

import SpriteKit
import Foundation

class GameOverSceneController {
    
    weak var gameOverDelegate: GameOverLogicDelegate?
    
    func currentScore() {
        
       // let currentScore = UserDefaults.standard.integer(forKey: "currentScore")
        //gameOverDelegate?.getScoreLabel().text = "your_score".localized() + "\(currentScore)"
        
        if currentScore > UserDefaults.standard.integer(forKey: GameCenterService.highscoreKey) {
            GameCenterService.shared.submitHighScore(score: currentScore) {error in
                if error == error {
                    UserDefaults.standard.set(currentScore, forKey: GameCenterService.highscoreKey)
                }
            }
        }
    }
}
