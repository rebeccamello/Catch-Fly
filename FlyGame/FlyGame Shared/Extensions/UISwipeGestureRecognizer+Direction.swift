//
//  UISwipeGestureRecognizer+Direction.swift
//  FlyGame
//
//  Created by Gui Reis on 24/03/22.
//

import UIKit

extension UISwipeGestureRecognizer.Direction {
    var direction: Direction? {
        switch self {
        case .up:
            return .up
        case .down:
            return .down
        default:
            return nil
        }
    }
}
