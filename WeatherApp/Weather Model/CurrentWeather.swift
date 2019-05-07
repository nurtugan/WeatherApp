//
//  CurrentWeather.swift
//  WeatherApp
//
//  Created by Nurtugan on 3/9/19.
//  Copyright © 2019 Ivan Akulov. All rights reserved.
//

import Foundation
import UIKit

struct CurrentWeather {
  let temperature: Double
  let apparentTemperature: Double
  let humidity: Double
  let pressure: Double
  let icon: UIImage
}

extension CurrentWeather: JSONDecodable {
  init?(JSON: [String : AnyObject]) {
    guard let temperature = JSON["temperature"] as? Double,
      let apparentTemperature = JSON["apparentTemperature"] as? Double,
      let humidity = JSON["humidity"] as? Double,
      let pressure = JSON["pressure"] as? Double,
      let iconString = JSON["icon"] as? String else {
        return nil
    }
    
    let icon = WeatherIconManager(rawValue: iconString).image
    
    self.temperature = (temperature - 32) / 1.8
    self.apparentTemperature = (apparentTemperature - 32) / 1.8
    self.humidity = humidity * 100
    self.pressure = pressure * 0.750062
    self.icon = icon
  }
}

extension CurrentWeather {
  var pressureString: String {
    return "\(Int(pressure)) mm"
  }
  
  var humidityString: String {
    return "\(Int(humidity)) %"
  }
  
  var temperatureString: String {
    return "\(Int(temperature))˚C"
  }
  
  var apparentTemperatureString: String {
    return "Feels like: \(Int(apparentTemperature))˚C"
  }
}
