//
//  ViewController.swift
//  how-weather-wear
//
//  Created by junehee on 6/19/24.
//

import UIKit
import MapKit

import Alamofire
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

    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkDeviceLocationAuthorization()
        
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
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        mapView.delegate = self
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
    
    // 현재 위치로 날씨 데이터 받기
    private func configureData(data: WeatherResult) {
        tempLabel.text = "\(Int(data.main.temp))º"
        tempMaxMinLabel.text = "오늘 최고 기온은 \(getFormattedDoubleToString(data.main.temp_max))º\n최저 기온은 \(getFormattedDoubleToString(data.main.temp_min))º 입니다"
        let iconImage = URL(string: "\(API.Weather.IMG)\(data.weather[0].icon)@2x.png")
        self.icon.kf.setImage(with: iconImage)
    }
    
    
    // 배경 흐림 설정
    private func setBlurEffect(blurEffect: UIBlurEffect.Style, target: UIView) {
        let blurEffect = UIBlurEffect(style: blurEffect)
        let effectView = UIVisualEffectView(effect: blurEffect)
        effectView.frame = view.bounds
        target.addSubview(effectView)
    }
}


// MARK: 권한 요청
extension MainViewController {
    /// 기기 위치 서비스 활성화 여부 체크 함수
    /// if-활성화 else-비활성화
    func checkDeviceLocationAuthorization() {
        if CLLocationManager.locationServicesEnabled() {
            /// 활성화되어 있는 경우 위치 권한 상태 체크 함수 실행
            checkCurrentLocatioinAuthorization()
        } else {
            print("위치 서비스가 활성화되어있지 않아, 위치 권한을 요청할 수 없어요.")
        }
    }
    
    /// 사용자의 위치 권한 상태 체크 함수
    func checkCurrentLocatioinAuthorization() {
        var status: CLAuthorizationStatus
        
        /// iOS 14 이전 버전 대응
        if #available(iOS 14.0, *) {
            status = locationManager.authorizationStatus
        } else {
            status = CLLocationManager.authorizationStatus()
        }
        
        /// 권한 상태별 핸들링
        /// notDetermined:
        switch status {
        case .notDetermined:
            print(status)
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            
        case .restricted:
            print(status)

        case .denied:
            print(status)

        case .authorizedAlways:
            print(status)

        case .authorizedWhenInUse:
            print(status)
            locationManager.startUpdatingLocation()   // didUpdateLocations 연결
            
        case .authorized:
            print(status)

        @unknown default:
            print(status)

        }
    }
    
    // 지도에 현재 위치 표시
    func setRegionAndAnnotation(center: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(region, animated: true)
    }
    
    // OpenWeather API
    func callRequest(coordinate: CLLocationCoordinate2D) {
        let URL = "\(API.Weather.URL)appid=\(API.Weather.KEY)&lat=\(coordinate.latitude)&lon=\(coordinate.longitude)"
        
        AF.request(URL).responseDecodable(of: WeatherResult.self) { res in
            switch res.result {
            case .success(let value):
                self.configureData(data: value)
            case .failure(let error):
                print("네트워크 통신 오류")
                print(error)
            }
        }
    }
    
    // 소수점 2번째 자리에서 반올림
    func getFormattedDoubleToString(_ value: Double) -> String {
        return String(format: "%.1f", value)
    }
}


// MARK: CLLocationManagerDelegate
extension MainViewController: CLLocationManagerDelegate {
    /// 사용자 위치를 성공적으로 가지고 온 경우
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coordinate = locations.last?.coordinate {
            // 현재 위치 주소 받아오기 (e.g. "00시, 00구")
            let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            let geocoder = CLGeocoder()
            
            geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
                if error != nil {
                    print("현재 위치 주소를 가져오지 못했어요.")
                    return
                }
                
                guard let city = placemarks?.first?.administrativeArea,
                      let subLocality = placemarks?.first?.subLocality else {
                    print("placemarks 주소 정보 오류")
                    return
                }
                self.locationLabel.text = "\(city), \(subLocality)"
            }
            
            // 지도에 위도.경도 세팅
            setRegionAndAnnotation(center: coordinate)
            callRequest(coordinate: coordinate)
        }
        
        locationManager.stopUpdatingLocation()
    }
    
    /// 사용자 위치를 가지고 오지 못한 경우
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print("위치를 가져올 수 없어요. 다시 시도해 주세요.")
    }
    
    /// 사용자의 권한 상태가 변경되었을 경우
    /// iOS 14 이상
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkDeviceLocationAuthorization()
    }
    
    /// iOS 14 이전
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkDeviceLocationAuthorization()
    }
}


// MARK: MapViewDelegate
extension MainViewController: MKMapViewDelegate {
    // 지도에서 위치가 움직일 때 데이터 재조정
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        print(#function, "위치가 변경됐어요.")
    }
}
