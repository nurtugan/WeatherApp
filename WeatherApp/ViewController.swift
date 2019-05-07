//
//  ViewController.swift
//  WeatherApp
//
//  Created by Ivan Akulov on 24/08/16.
//  Copyright © 2016 Ivan Akulov. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

  @IBOutlet weak var locationLabel: UILabel!
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var pressureLabel: UILabel!
  @IBOutlet weak var humidityLabel: UILabel!
  @IBOutlet weak var temperatureLabel: UILabel!
  @IBOutlet weak var appearentTemperatureLabel: UILabel!
  @IBOutlet weak var refreshButton: UIButton!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
  let locationManager = CLLocationManager()
  
  @IBAction func refreshButtonTapped(_ sender: UIButton) {
    toggleActivityIndicator(on: true)
    getCurrentWeatherData()
  }
  
  func toggleActivityIndicator(on: Bool) {
    refreshButton.isHidden = on
    
    if on {
      activityIndicator.startAnimating()
    } else {
      activityIndicator.stopAnimating()
    }
  }
  
  lazy var weatherManager = APIWeatherManager(apiKey: "178348bed04434fd518e9e57a5c8454b")
  let coordinates = Coordinates(latitude: 43.176008, longitude: 76.872565)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    locationManager.requestAlwaysAuthorization()
    locationManager.startUpdatingLocation()
    
    getCurrentWeatherData()
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    
    guard let userLocation = locations.last else {
      return
    }
    
    print("My location latitude: \(userLocation.coordinate.latitude), longitude: \(userLocation.coordinate.longitude)")
  }
  
  func getCurrentWeatherData() {
    weatherManager.fetchCurrentWeatherWith(coordinates: coordinates) { (result) in
      
      self.toggleActivityIndicator(on: false)
      
      switch result {
      case .Success(let currentWeather):
        self.updateUIWith(currentWeather: currentWeather)
      case .Failure(let error as NSError):
        
        let alertController = UIAlertController(title: "Unable to get data", message: "\(error.localizedDescription)", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
      default: break
      }
    }
  }

  func updateUIWith(currentWeather: CurrentWeather) {
    self.imageView.image = currentWeather.icon
    self.pressureLabel.text = currentWeather.pressureString
    self.humidityLabel.text = currentWeather.humidityString
    self.temperatureLabel.text = currentWeather.temperatureString
    self.appearentTemperatureLabel.text = currentWeather.apparentTemperatureString
  }
  
}

