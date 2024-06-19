//
//  UILabel+Extension.swift
//  how-weather-wear
//
//  Created by junehee on 6/19/24.
//

import UIKit

extension UILabel {
    func setText(color: UIColor, size: CGFloat, weight: UIFont.Weight) {
        self.textColor = color
        self.textAlignment = .center
        self.font = .systemFont(ofSize: size, weight: weight)
    }
    
    func setShadowText(color: UIColor, size: CGFloat, weight: UIFont.Weight) {
        self.textColor = color
        self.textAlignment = .center
        self.font = .systemFont(ofSize: size, weight: weight)
        self.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.layer.shadowOpacity = 0.3
        self.layer.shadowRadius = 1
    }
}
