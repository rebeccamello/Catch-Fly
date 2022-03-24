//
//  GameViewController.swift
//  FlyGame iOS
//
//  Created by Nathalia do Valle Papst on 07/03/22.
//

import SpriteKit


class GameViewController: MenuViewController {
    
    /* MARK: - Atributos */
    
    override var preferredScreenEdgesDeferringSystemGestures: UIRectEdge {
        return UIRectEdge.bottom
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
