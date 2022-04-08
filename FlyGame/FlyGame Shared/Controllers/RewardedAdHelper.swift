//
//  RewardedAd.swift
//  FlyGame
//
//  Created by Rebecca Mello on 07/04/22.
//

import Foundation
import GoogleMobileAds
import SpriteKit

class RewardedAdHelper: NSObject, GADFullScreenContentDelegate {
    private var rewardedAd: GADRewardedAd?
    
    func loadRewardedAd() {
        // teste id ca-app-pub-3940256099942544/1712485313
        // do app: ca-app-pub-1021015536387349/6793205108
        let request = GADRequest()
        GADRewardedAd.load(withAdUnitID: "ca-app-pub-3940256099942544/1712485313", request: request) { [self] ad, error in
            if let error = error {
                print("Failed to load rewarded ad with error ", error)
                return
            }
            
            rewardedAd = ad
            rewardedAd?.fullScreenContentDelegate = self
        }
    }
    
    func showRewardedAd(vc: UIViewController) {
        if let ad = rewardedAd {
            ad.present(fromRootViewController: vc) {
//                let reward = ad.adReward
                self.continueGame()
            }
        } else {
            print("Ad wasn't ready")
        }
    }
    
    func continueGame() {
        print("vai continuar")
    }
    
    // MARK: GADFullScreenContentDelegate
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Rewarded ad dismissed.")
        self.loadRewardedAd()
    }
    
//    func ad(
//        _ ad: GADFullScreenPresentingAd,
//        didFailToPresentFullScreenContentWithError error: Error
//    ) {
//        print("Rewarded ad failed to present with error: \(error.localizedDescription).")
//        let alert = UIAlertController(
//            title: "Wait a minute!",
//            message: "We do not have ads to show right now!",
//            preferredStyle: .alert)
//        let alertAction = UIAlertAction(
//            title: "OK",
//            style: .cancel,
//            handler: nil)
//        alert.addAction(alertAction)
//        self.present(alert, animated: true, completion: nil)
//    }
}
