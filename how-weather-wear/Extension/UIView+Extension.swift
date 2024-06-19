//
//  UIView+Extension.swift
//  how-weather-wear
//
//  Created by junehee on 6/19/24.
//

import UIKit

extension UIView {
    func setWhiteTransparentBackground() {
        self.backgroundColor = .init(_colorLiteralRed: 1, green: 1, blue: 1, alpha: 0.5)
        self.isOpaque = true
        self.clipsToBounds = true
        self.layer.cornerRadius = 10
    }
}
