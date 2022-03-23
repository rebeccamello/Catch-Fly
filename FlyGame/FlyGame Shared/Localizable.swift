//
//  Localizable.swift
//  FlyGame iOS
//
//  Created by Rebecca Mello on 23/03/22.
//

import Foundation
import UIKit

enum Localizable: String {
    case yourScore = "your_score"
    case highscore = "highscore"
}

func NSLocalizedString(_ localizable: Localizable) -> String {
    return NSLocalizedString(localizable.rawValue, comment: "")
}
