//
//  MenuLogicDelegate.swift
//  FlyGame
//
//  Created by Nathalia do Valle Papst on 07/03/22.
//

import Foundation
import SpriteKit

protocol MenuLogicDelegate {
    func goToGameCenter() -> Void
    func getMusicButton() -> SKButtonNode
    func getSoundButton() -> SKButtonNode
}
