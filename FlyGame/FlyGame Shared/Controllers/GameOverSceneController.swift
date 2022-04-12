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
    private var rewardedAd: GADRewardedAd?
    
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
    
    // MARK: Ads
    func loadRewardedAd() {
        // teste id ca-app-pub-3940256099942544/1712485313
        // do app: ca-app-pub-1021015536387349/6793205108
        let request = GADRequest()
        GADRewardedAd.load(withAdUnitID: "ca-app-pub-3940256099942544/1712485313", request: request) { [self] ad, error in
            if let error = error {
                print("Failed to load rewarded ad with error ", error)
                return
            }
            print("no load")
            rewardedAd = ad
            rewardedAd?.fullScreenContentDelegate = self
        }
    }
    
    func showRewardedAd() {
        //        self.gameOverDelegate?.continueGameAfterAds()
        if let ad = rewardedAd {
            ad.present(fromRootViewController: self) {
                print("aqui")
                self.gameOverDelegate?.continueGameAfterAds()
            }
        } else {
            print("Ad wasn't ready")
        }
    }
    
    // MARK: GADFullScreenContentDelegate
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Rewarded ad dismissed.")
        self.loadRewardedAd()
    }
    
    // Calling Ad
    func ad(
        _ ad: GADFullScreenPresentingAd,
        didFailToPresentFullScreenContentWithError error: Error
    ) {
        print("Rewarded ad failed to present with error: \(error.localizedDescription).")
        let alert = UIAlertController(
            title: "Wait a minute!",
            message: "We do not have ads to show right now!",
            preferredStyle: .alert)
        let alertAction = UIAlertAction(
            title: "OK",
            style: .cancel,
            handler: nil)
        alert.addAction(alertAction)
        self.present(alert, animated: true, completion: nil)
    }
}
