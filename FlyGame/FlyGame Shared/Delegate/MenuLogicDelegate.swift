//
//  MenuLogicDelegate.swift
//  FlyGame
//
//  Created by Nathalia do Valle Papst on 07/03/22.
//
// swiftlint:disable class_delegate_protocol
import Foundation
import SpriteKit

protocol MenuLogicDelegate {
    func goToGameCenter()
    func getMusicButton() -> SKButtonNode
    func getSoundButton() -> SKButtonNode
}
