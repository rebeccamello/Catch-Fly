//
//  TutorialSceneController.swift
//  FlyGame
//
//  Created by Caroline Taus on 24/03/22.
//

import Foundation
import SpriteKit

class TutorialSceneController {
     var currentPosition: Int = 3
    func movePlayer(direction: Direction) -> CGFloat {
        var newPosition = currentPosition
        if direction == .up {
            if currentPosition != 5 {
                newPosition += 2
            }
        } else {
            if currentPosition != 1 {
                newPosition -= 2
            }
        }
        currentPosition = newPosition
        return CGFloat(newPosition)
    }
}
