//
//  MenuViewController.swift
//  FlyGame
//
//  Created by Gui Reis on 24/03/22.
//

import UIKit
import SpriteKit
import GoogleMobileAds

class MenuViewController: UIViewController {
    private var rewardedAd: GADRewardedAd?
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func loadView() {
        let scene = MenuScene.newGameScene()
        
        let skView = SKView()
        skView.ignoresSiblingOrder = true
        skView.presentScene(scene)
        self.view = skView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        GameCenterService.shared.setController(self)
        gameCenterVerification()
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = [ "2077ef9a63d2b398840261c8221a0c9b" ]
        setupBindings()
    }
    
    func setupBindings() {
        NotificationCenter.default.addObserver(self, selector: #selector(runAd), name: .init(rawValue: "loadAd"), object: nil)
    }
    
    @objc func runAd() {
        loadRewardedAd()
    }
    
    func gameCenterVerification() {
        // Fazendo a autenticação com o Game Center
        GameCenterService.shared.autenticateUser {vct, score, error in
            if error != nil {
                return
            }
            if let vct = vct {
                self.present(vct, animated: true)
                return
            }
            if let score = score {
                guard let scene = (self.view as? SKView)?.scene as? MenuScene else {return}
                scene.setScore(with: score)
            }
        }
    }
    
    func loadRewardedAd() {
        // teste id ca-app-pub-3940256099942544/1712485313
        // do app: ca-app-pub-1021015536387349/6793205108
        let request = GADRequest()
        GADRewardedAd.load(withAdUnitID: "ca-app-pub-3940256099942544/1712485313", request: request) { [weak self] ad, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Failed to load rewarded ad with error ", error)
                return
            }
            self.rewardedAd = ad
            self.rewardedAd?.fullScreenContentDelegate = self
            self.showRewardedAd()
        }
    }
    
    func showRewardedAd() {
        //        self.gameOverDelegate?.continueGameAfterAds()
        if let ad = rewardedAd {
            ad.present(fromRootViewController: self) {
                NotificationCenter.default.post(name: .init(rawValue: "callAd"), object: nil)
                //self.gameOverDelegate?.continueGameAfterAds()
            }
        } else {
            print("Ad wasn't ready")
        }
    }
}

extension MenuViewController: GADFullScreenContentDelegate {
    // MARK: GADFullScreenContentDelegate
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Rewarded ad dismissed.")
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
