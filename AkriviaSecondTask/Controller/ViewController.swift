//
//  ViewController.swift
//  AkriviaSecondTask
//
//  Created by Pradeep on 17/07/20.
//  Copyright © 2020 Pradeep. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController{
    
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var latValue: UILabel!
    @IBOutlet weak var lonValue: UILabel!
    @IBOutlet weak var addressValue: UILabel!
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var sunrise: UILabel!
    @IBOutlet weak var sunset: UILabel!
    @IBOutlet weak var tempreture: UILabel!
    @IBOutlet weak var minTempreture: UILabel!
    @IBOutlet weak var maxTempreture: UILabel!
    @IBOutlet weak var Description: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var weatherView: UIView!
    
    var httpUtility:HttpUtility?
    var currentLocationValue: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.weatherView.layer.cornerRadius = 10.0
        httpUtility = HttpUtility()
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        //self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
}

extension ViewController: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if currentLocationValue == nil {
            guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
            print("locations = \(locValue.latitude) \(locValue.longitude)")
            currentLocationValue = locValue
            self.latValue.text = String(format: "%.4f", locValue.latitude)
            self.lonValue.text = String(format: "%.4f", locValue.longitude)
            let loc: CLLocation = CLLocation(latitude:locValue.latitude, longitude: locValue.longitude)
            let ceo: CLGeocoder = CLGeocoder()
            var cityName = ""
            
            ceo.reverseGeocodeLocation(loc, completionHandler:
                {(placemarks, error) in
                    if (error != nil)
                    {
                        print("reverse geodcode fail: \(error!.localizedDescription)")
                    }
                    let pm = placemarks! as [CLPlacemark]
                    
                    if pm.count > 0 {
                        let pm = placemarks![0]
                        
                        var addressString : String = ""
                        if pm.subLocality != nil {
                            addressString = addressString + pm.subLocality! + ", "
                        }
                        if pm.thoroughfare != nil {
                            addressString = addressString + pm.thoroughfare! + ", "
                        }
                        if pm.locality != nil {
                            addressString = addressString + pm.locality! + ", "
                            cityName = pm.locality ?? "Bangalore"
                        }
                        if pm.country != nil {
                            addressString = addressString + pm.country! + ", "
                        }
                        if pm.postalCode != nil {
                            addressString = addressString + pm.postalCode! + " "
                        }
                        
                        
                        print(addressString)
                        self.addressValue.text = addressString
                        self.retrieveWeatherDataFromApi(cityName: cityName)
                    }
            })
        }
    }
    
    func retrieveWeatherDataFromApi(cityName:String) {
        
        
        let weatherApiUrlString = "\(Common.weatherApi)\(cityName)\(Common.weatherApiKey)"
        print("weatherApiUrlString = \(weatherApiUrlString)")
        
        httpUtility?.getApiData(requestUrl: weatherApiUrlString, resultType: WeatherResponse.self) { (weatherResponse) in
            
            debugPrint("WeatherResponse = \(weatherResponse)")
            
            let name = weatherResponse.name
            let description = weatherResponse.weather[0].weatherDescription
            let temp = weatherResponse.main.temp
            let mxTemp = weatherResponse.main.tempMax
            let minTemp = weatherResponse.main.tempMin
            let dt = Double(weatherResponse.dt)
            let sunrise = weatherResponse.sys.sunrise
            let sunset = weatherResponse.sys.sunset
            
            DispatchQueue.main.sync {
                let tempreture = Common.convertTemp(temp: temp , from: .kelvin, to: .celsius)
                let maxTempreture = Common.convertTemp(temp: mxTemp, from: .kelvin, to: .celsius)
                let minTempreture = Common.convertTemp(temp: minTemp, from: .kelvin, to: .celsius)
                
                print("name = \(name)")
                print("description = \(description)")
                self.Description.text = "Today:\(description).It's \(tempreture); The high will be \(maxTempreture). Clear tonight with a low of \(minTempreture)"
                self.tempreture.text = tempreture
                self.maxTempreture.text = maxTempreture
                self.minTempreture.text = minTempreture
                print("dt = \(dt)")
                let dateString = Common.convertEpocToTime(epocValue: dt)
                self.date.text = dateString
                self.sunrise.text = Common.convertEpocToTime(epocValue: Double(sunrise))
                self.sunset.text = Common.convertEpocToTime(epocValue: Double(sunset))
                print("sunset = \(sunset)")
            }
        }
        
    }
}
