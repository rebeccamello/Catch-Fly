//
//  GameOverController.swift
//  FlyGame
//
//  Created by Nathalia do Valle Papst on 07/03/22.
//

import SpriteKit
import Foundation
import GoogleMobileAds
import UIKit

class GameOverSceneController: UIViewController, GADFullScreenContentDelegate {
    
    weak var gameOverDelegate: GameOverLogicDelegate?
    let tapGeneralSelection = UITapGestureRecognizer()
    var rewardedAd = RewardedAdHelper()
    
    func currentScore(currentScore: Int) {
        if currentScore > UserDefaults.standard.integer(forKey: GameCenterService.highscoreKey) {
            GameCenterService.shared.submitHighScore(score: currentScore) {error in
                if error == error {
                    UserDefaults.standard.set(currentScore, forKey: GameCenterService.highscoreKey)
                }
            }
        }
    }
    
    #if os(tvOS)
    func addTargetToGestureRecognizer() -> UITapGestureRecognizer {
        tapGeneralSelection.addTarget(self, action: #selector(clicked))
        return tapGeneralSelection
    }
    
    @objc func clicked() {
        if gameOverDelegate?.getButtons()[0].isFocused == true {
            gameOverDelegate?.goToMenu()
        } else if gameOverDelegate?.getButtons()[1].isFocused == true {
           gameOverDelegate?.restartGame()
        }
    }
    #endif
    
    //MARK: Ads
    func callAds() {
        rewardedAd.showRewardedAd(vc: self)
    }
}
