//
//  Model.swift
//  how-weather-wear
//
//  Created by junehee on 6/19/24.
//

import Foundation

struct WeatherResult: Decodable {
    let coord: WeatherCoord
    let weather: [WeatherData]
    let main: WeatherMain
}

struct WeatherCoord: Decodable {
    let lon: Double
    let lat: Double
}

struct WeatherData: Decodable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct WeatherMain: Decodable {
    let temp: Double
    let temp_min: Double
    let temp_max: Double
}
