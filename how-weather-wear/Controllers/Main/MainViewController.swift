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

class MainViewController: BaseViewController {
    
    private let mainView = MainView()

    let locationManager = CLLocationManager()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkDeviceLocationAuthorization()
    }
    
    
    override func configureViewController() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        mainView.mapView.delegate = self
    }
    
    // 현재 위치로 날씨 데이터 받기
    private func configureData(data: WeatherResult) {
        mainView.tempLabel.text = "\(Int(data.main.temp))º"
        mainView.tempMaxMinLabel.text = "오늘 최고 기온은 \(getFormattedDoubleToString(data.main.temp_max))º\n최저 기온은 \(getFormattedDoubleToString(data.main.temp_min))º 입니다"
        let iconImage = URL(string: "\(API.Weather.IMG)\(data.weather[0].icon)@2x.png")
        mainView.icon.kf.setImage(with: iconImage)
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
        mainView.mapView.setRegion(region, animated: true)
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
                self.mainView.locationLabel.text = "\(city), \(subLocality)"
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
