//
//  String+Localized.swift
//  FlyGame
//
//  Created by Gui Reis on 24/03/22.
//

import func Foundation.NSLocalizedString

extension String {
    func localized() -> String {
        return NSLocalizedString(
            self,
            tableName: "Localizable",
            bundle: .main,
            value: self,
            comment: self
        )
    }
}
