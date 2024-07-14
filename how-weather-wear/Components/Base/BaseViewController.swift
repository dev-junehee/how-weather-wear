//
//  BaseViewController.swift
//  how-weather-wear
//
//  Created by junehee on 7/13/24.
//

import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureHierarchy()
        configureLayout()
        configureUI()
    }
    
    func configureViewController() { }
        
    func configureHierarchy() { }
    
    func configureLayout() { }
    
    func configureUI() {
        view.backgroundColor = .white
    }
    
}
