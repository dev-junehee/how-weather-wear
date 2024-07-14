//
//  MainView.swift
//  how-weather-wear
//
//  Created by junehee on 7/13/24.
//

import UIKit
import MapKit

import SnapKit

final class MainView: BaseView {
    
    let scrollView = UIScrollView()
    
    let mainView = UIView()
    
    let locationLabel = UILabel()
    let tempLabel = UILabel()
    let weatherLabel = UILabel()
    let tempMaxMinLabel = UILabel()
    
    let tableView = UITableView()
    
    override func configureViewHierarchy() {
        let subViews = [locationLabel, tempLabel, weatherLabel, tempMaxMinLabel]
        subViews.forEach {
            mainView.addSubview($0)
        }
        
        let subScrollViews = [mainView, tableView]
        subScrollViews.forEach {
            scrollView.addSubview($0)
        }
        
        self.addSubview(scrollView)
    }
    
    override func configureViewLayout() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        mainView.snp.makeConstraints {
            
            
            $0.top.horizontalEdges.equalTo(self.safeAreaLayoutGuide)
            $0.height.equalTo(400)
            $0.bottom.equalTo(tableView.snp.top)
        }
        
        locationLabel.snp.makeConstraints {
            $0.top.centerX.equalTo(self.safeAreaLayoutGuide)
        }
        
        tempLabel.snp.makeConstraints {
            $0.top.equalTo(locationLabel.snp.bottom)
            $0.centerX.equalTo(self.safeAreaLayoutGuide)
        }
        
        weatherLabel.snp.makeConstraints {
            $0.top.equalTo(tempLabel.snp.bottom)
            $0.centerX.equalTo(self.safeAreaLayoutGuide)
        }
        
        tempMaxMinLabel.snp.makeConstraints {
            $0.top.equalTo(weatherLabel.snp.bottom)
            $0.centerX.equalTo(self.safeAreaLayoutGuide)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(mainView.snp.bottom).offset(20)
            $0.height.equalTo(1000)
            $0.horizontalEdges.equalTo(self.safeAreaLayoutGuide)
        }
    }

    override func configureViewUI() {
        // 확인용 임시 데이터
        scrollView.backgroundColor = .systemPink
        
        mainView.backgroundColor = .lightGray
        
        locationLabel.font = .systemFont(ofSize: 40, weight: .light)
        tempLabel.font = .systemFont(ofSize: 80, weight: .light)
        weatherLabel.font = .systemFont(ofSize: 20, weight: .regular)
        tempMaxMinLabel.font = .systemFont(ofSize: 20, weight: .regular)
        
        locationLabel.text = "Jeju City"
        tempLabel.text = "24.7º"
        weatherLabel.text = "Broken Clouds"
        tempMaxMinLabel.text = "최고 : 7.0º | 최저 : -4.2º"
        
        tableView.backgroundColor = .blue
    }
    
}
