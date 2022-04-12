//
//  UIScreen+CGSize.swift
//  FlyGame
//
//  Created by Caroline Taus on 15/03/22.
//

import Foundation
import SpriteKit

extension CGSize {
    static func screenSize(widthMultiplier: CGFloat = 1, heighMultiplier: CGFloat = 1) -> CGSize {
        CGSize(width: UIScreen.main.bounds.size.width*widthMultiplier,
               height: UIScreen.main.bounds.size.height*heighMultiplier)
    }
}
