//
//  AudioDelegate.swift
//  FlyGame
//
//  Created by Nathalia do Valle Papst on 07/03/22.
//

import Foundation

protocol AudioDelegate: AnyObject {
    func toggleSound() -> SKButtonNode
    
    func toggleMusic() -> SKButtonNode
}
