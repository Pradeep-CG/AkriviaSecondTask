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
}
