//
//  BaseView.swift
//  how-weather-wear
//
//  Created by junehee on 7/13/24.
//

import UIKit

class BaseView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViewHierarchy()
        configureViewLayout()
        configureViewUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureViewHierarchy() { }
    
    func configureViewLayout() { }
    
    func configureViewUI() { }
    
}
