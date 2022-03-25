//
//  GameCenterDelegate.swift
//  FlyGame
//
//  Created by Gui Reis on 23/03/22.
//

import GameKit

class GameCenterDelegate: NSObject, GKGameCenterControllerDelegate {
    
    /* MARK: - Delegate */
    
    public func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
}
