//
//  ViewController.swift
//  how-weather-wear
//
//  Created by junehee on 6/19/24.
//

import UIKit
import MapKit

import Kingfisher
import SnapKit

class MainViewController: UIViewController {
    
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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
        configureLayout()
        configureUI()
    }
    
    private func configureHierarchy() {
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
            view.addSubview($0)
        }
    }
    
    private func configureLayout() {
        background.snp.makeConstraints {
            $0.edges.equalTo(view)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(40)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(40)
        }
        
        locationLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(20)
        }
        
        tempLabel.snp.makeConstraints {
            $0.top.equalTo(locationLabel.snp.bottom).offset(16)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(100)
        }
        
        subInfoStack.snp.makeConstraints {
            $0.top.equalTo(tempLabel.snp.bottom).offset(16)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
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
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
            $0.bottom.equalTo(view)
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

    private func configureUI() {
        // 배경
        let backgroundImage = URL(string: Resource.Images.background)
        background.kf.setImage(with: backgroundImage)
        background.contentMode = .scaleAspectFill
        setBlurEffect(blurEffect: .light, target: background)
        
        // 메인 레이블
        titleLabel.text = "나의 위치"
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.font = .systemFont(ofSize: 32, weight: .light)
        titleLabel.layer.shadowOffset = CGSize(width: 2, height: 2)
        titleLabel.layer.shadowOpacity = 0.3
        titleLabel.layer.shadowRadius = 1
        
        // 위치 레이블
        locationLabel.text = "서울특별시, 중구"
        locationLabel.textColor = .white
        locationLabel.textAlignment = .center
        locationLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        locationLabel.layer.shadowOffset = CGSize(width: 2, height: 2)
        locationLabel.layer.shadowOpacity = 0.3
        locationLabel.layer.shadowRadius = 1
        
        // 현재온도 레이블
        tempLabel.text = "32º"
        tempLabel.textColor = .white
        tempLabel.textAlignment = .center
        tempLabel.font = .systemFont(ofSize: 100, weight: .ultraLight)
        tempLabel.layer.shadowOffset = CGSize(width: 2, height: 2)
        tempLabel.layer.shadowOpacity = 0.3
        tempLabel.layer.shadowRadius = 1
        
        // 최고+최저온도, 아이콘 스택
        subInfoStack.backgroundColor = .init(_colorLiteralRed: 1, green: 1, blue: 1, alpha: 0.5)
        subInfoStack.isOpaque = true
        subInfoStack.clipsToBounds = true
        subInfoStack.layer.cornerRadius = 10
        
        // 최고+최저온도 레이블
        tempMaxMinLabel.numberOfLines = 0
        tempMaxMinLabel.text = "오늘 최고 기온은 32º\n최저 기온은 32º 입니다"
        tempMaxMinLabel.textColor = .white
        tempMaxMinLabel.textAlignment = .center
        tempMaxMinLabel.font = .systemFont(ofSize: 16, weight: .light)
        tempMaxMinLabel.layer.shadowOffset = CGSize(width: 2, height: 2)
        tempMaxMinLabel.layer.shadowOpacity = 0.5
        tempMaxMinLabel.layer.shadowRadius = 1
        
        // 아이콘 이미지
        icon.backgroundColor = .white
        icon.contentMode = .scaleAspectFit
        let iconImage = URL(string: "https://openweathermap.org/img/wn/10d@2x.png")
        icon.kf.setImage(with: iconImage)
        
        // 지도 백그라운드 뷰
        mapBackgroundView.backgroundColor = .init(_colorLiteralRed: 1, green: 1, blue: 1, alpha: 0.5)
        mapBackgroundView.isOpaque = true
        mapBackgroundView.clipsToBounds = true
        mapBackgroundView.layer.cornerRadius = 10
        
        // 지도 텍스트
        mapLabel.text = "현재 위치"
        mapLabel.font = .systemFont(ofSize: 14, weight: .bold)
        mapLabel.textColor = .lightGray
        
        // 지도
        mapView.layer.cornerRadius = 5
    }
    
    // 배경 흐림 설정
    func setBlurEffect(blurEffect: UIBlurEffect.Style, target: UIView) {
        let blurEffect = UIBlurEffect(style: blurEffect)
        let effectView = UIVisualEffectView(effect: blurEffect)
        effectView.frame = view.bounds
        target.addSubview(effectView)
    }
}

