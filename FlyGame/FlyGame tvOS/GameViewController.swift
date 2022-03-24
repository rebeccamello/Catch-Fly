//
//  GameViewController.swift
//  FlyGame tvOS
//
//  Created by Nathalia do Valle Papst on 07/03/22.
//

import SpriteKit


class GameViewController: MenuViewController {
    
    /* MARK: - Atributos */
    
    override var preferredFocusEnvironments: [UIFocusEnvironment] {
         if let scene = (view as? SKView)?.scene {
             return [scene]
         }
         return []
    }
}
