//
//  Common.swift
//  AkriviaSecondTask
//
//  Created by Pradeep on 17/07/20.
//  Copyright © 2020 Pradeep. All rights reserved.
//

import Foundation
import UIKit

struct Common {
    static let weatherApi = "https://api.openweathermap.org/data/2.5/weather?q="
    static let weatherApiKey = "&appid=66c3fd0cb6de2383542585703136321a"
    
    static func verifyUrl (urlString: String?) -> Bool {
        if let urlString = urlString {
            if let url = NSURL(string: urlString) {
                return UIApplication.shared.canOpenURL(url as URL)
            }
        }
        return false
    }
    
    static func convertTemp(temp: Double, from inputTempType: UnitTemperature, to outputTempType: UnitTemperature) -> String {
        let mf = MeasurementFormatter()

      mf.numberFormatter.maximumFractionDigits = 0
      mf.unitOptions = .providedUnit
      let input = Measurement(value: temp, unit: inputTempType)
      let output = input.converted(to: outputTempType)
      return mf.string(from: output)
    }
    
    static func convertEpocToTime(epocValue:Double) -> String{
        
         let date = Date(timeIntervalSince1970: epocValue)
         let dateFormatter = DateFormatter()
         dateFormatter.timeStyle = DateFormatter.Style.medium //Set time style
        // dateFormatter.dateStyle = DateFormatter.Style.medium //Set date style
         dateFormatter.timeZone = .current
         let localTime = dateFormatter.string(from: date)
        print("local time = \(localTime)")
        return localTime
    }
}
