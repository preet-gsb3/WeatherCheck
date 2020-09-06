// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let weatherResponseModel = try? newJSONDecoder().decode(WeatherResponseModel.self, from: jsonData)

import Foundation

// MARK: - WeatherResponseModel
struct WeatherResponseModel: Codable {
    let coord: WeatherResponseCoord?
    let weather: [WeatherResponseWeather]?
    let base: String?
    let main: WeatherResponseMain?
    let visibility: Int?
    let wind: WeatherResponseWind?
    let clouds: WeatherResponseClouds?
    let dt: Int?
    let sys: WeatherResponseSys?
    let timezone, id: Int?
    let name: String?
    let cod: Int?
}

// MARK: - WeatherResponseClouds
struct WeatherResponseClouds: Codable {
    let all: Int?
}

// MARK: - WeatherResponseCoord
struct WeatherResponseCoord: Codable {
    let lon, lat: Double?
}

// MARK: - WeatherResponseMain
struct WeatherResponseMain: Codable {
    let temp, feelsLike, tempMin, tempMax: Double?
    let pressure, humidity, seaLevel, grndLevel: Int?

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
    }
}

// MARK: - WeatherResponseSys
struct WeatherResponseSys: Codable {
    let country: String?
    let sunrise, sunset: Int?
}

// MARK: - WeatherResponseWeather
struct WeatherResponseWeather: Codable {
    let id: Int?
    let main, weatherDescription, icon: String?

    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
        case icon
    }
}

// MARK: - WeatherResponseWind
struct WeatherResponseWind: Codable {
    let speed: Double?
    let deg: Int?
}
