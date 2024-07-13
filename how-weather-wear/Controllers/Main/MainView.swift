//
//  MainView.swift
//  how-weather-wear
//
//  Created by junehee on 7/13/24.
//

import UIKit
import MapKit

final class MainView: BaseView {
    
    let background = UIImageView()
    
    let titleLabel = UILabel()
    let locationLabel = UILabel()
    let tempLabel = UILabel()
    
    let subInfoStack = UIStackView()
    let tempMaxMinLabel = UILabel()
    let icon = UIImageView()
    
    let mapBackgroundView = UIView()
    let mapLabel = UILabel()
    let mapView = MKMapView()
    
    override func configureViewHierarchy() {
        let infoSubViews = [tempMaxMinLabel, icon]
        infoSubViews.forEach {
            subInfoStack.addArrangedSubview($0)
        }
        
        let mapSubViews = [mapLabel, mapView]
        mapSubViews.forEach {
            mapBackgroundView.addSubview($0)
        }
        
        let subViews = [
            background, titleLabel, locationLabel,
            tempLabel, subInfoStack, mapBackgroundView
        ]
        subViews.forEach {
            self.addSubview($0)
        }
        
        
    }
    
    override func configureViewLayout() {
        background.snp.makeConstraints {
            $0.edges.equalTo(self)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(40)
            $0.horizontalEdges.equalTo(self.safeAreaLayoutGuide)
            $0.height.equalTo(40)
        }
        
        locationLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.horizontalEdges.equalTo(self.safeAreaLayoutGuide)
            $0.height.equalTo(20)
        }
        
        tempLabel.snp.makeConstraints {
            $0.top.equalTo(locationLabel.snp.bottom).offset(16)
            $0.horizontalEdges.equalTo(self.safeAreaLayoutGuide)
            $0.height.equalTo(100)
        }
        
        subInfoStack.snp.makeConstraints {
            $0.top.equalTo(tempLabel.snp.bottom).offset(16)
            $0.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(24)
            $0.height.equalTo(120)
        }
        subInfoStack.axis = .horizontal
        
        tempMaxMinLabel.snp.makeConstraints {
            $0.verticalEdges.equalTo(subInfoStack)
            $0.leading.equalTo(subInfoStack.snp.leading)
        }
        
        icon.snp.makeConstraints {
            $0.leading.equalTo(tempMaxMinLabel.snp.trailing)
            $0.trailing.equalTo(subInfoStack.snp.trailing)
            $0.width.equalTo(100)
        }
        
        mapBackgroundView.snp.makeConstraints {
            $0.top.equalTo(subInfoStack.snp.bottom).offset(16)
            $0.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(24)
            $0.bottom.equalTo(self)
        }
        
        mapLabel.snp.makeConstraints {
            $0.top.equalTo(mapBackgroundView.snp.top).offset(12)
            $0.horizontalEdges.equalTo(mapBackgroundView).offset(24)
            $0.height.equalTo(20)
        }
        
        mapView.snp.makeConstraints {
            $0.top.equalTo(mapLabel.snp.bottom).offset(8)
            $0.horizontalEdges.bottom.equalTo(mapBackgroundView).inset(16)
        }
    }

    override func configureViewUI() {
        // 배경
        let backgroundImage = URL(string: Resource.Images.background)
        background.kf.setImage(with: backgroundImage)
        background.contentMode = .scaleAspectFill
        setBlurEffect(blurEffect: .light, target: background)
        
        // 메인 레이블
        titleLabel.text = Constants.Text.Main.title
        titleLabel.setShadowText(color: Resource.Colors.white, size: 32, weight: .light)
        
        // 위치 레이블
        locationLabel.setShadowText(color: Resource.Colors.white, size: 16, weight: .semibold)
        
        // 현재온도 레이블
        tempLabel.setShadowText(color: Resource.Colors.white, size: 100, weight: .ultraLight)
        
        // 최고+최저온도, 아이콘 스택
        subInfoStack.setWhiteTransparentBackground()
        
        // 최고+최저온도 레이블
        tempMaxMinLabel.numberOfLines = 0
        tempMaxMinLabel.setText(color: Resource.Colors.darkGray, size: 16, weight: .medium)
        
        // 아이콘 이미지
        icon.backgroundColor = Resource.Colors.white
        icon.contentMode = .scaleAspectFit
        
        // 지도 백그라운드 뷰
        mapBackgroundView.setWhiteTransparentBackground()
        
        // 지도 뷰 타이틀 텍스트
        mapLabel.text = Constants.Text.Main.mapLabel
        mapLabel.font = Resource.Fonts.bold14
        mapLabel.textColor = Resource.Colors.lightGray
        
        // 지도
        mapView.layer.cornerRadius = 5
    }
}

extension MainView {
    // 배경 흐림 설정
    private func setBlurEffect(blurEffect: UIBlurEffect.Style, target: UIView) {
        let blurEffect = UIBlurEffect(style: blurEffect)
        let effectView = UIVisualEffectView(effect: blurEffect)
        effectView.frame = self.bounds
        target.addSubview(effectView)
    }
}
