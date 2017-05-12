//
//  ViewController.swift
//  Whats The Weather
//
//  Created by Enrique V. Kortright on 5/10/17.
//  Copyright © 2017 Enrique V. Kortright. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var url : URL? = nil

    @IBOutlet weak var cityTextField: UITextField!
    
    @IBAction func submitTapped(_ sender: Any) {
        if var city = cityTextField.text {
            city = city.replacingOccurrences(of: " ", with: "-")
            print("city: \(city)")
            let urlString = "http://www.weather-forecast.com/locations/" + city + "/forecasts/latest"
            url = URL(string: urlString)
            getForecast()
        }
    }
    
    @IBOutlet weak var forecastTextField: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func getForecast() {
        let request = NSMutableURLRequest(url: url!)
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            if error != nil {
                print("viewDidLoad error: \(error!)")
            } else if let unwrappedData = data {
                if let dataString = NSString(data: unwrappedData, encoding: String.Encoding.utf8.rawValue) {
                    let stringSeparator1 = "Weather Forecast Summary:</b><span class=\"read-more-small\"><span class=\"read-more-content\"> <span class=\"phrase\">"
                    let stringSeparator2 = "</span></span></span></p>"
                    let contentArray = dataString.components(separatedBy: stringSeparator1)
                    let forecast = contentArray[1].components(separatedBy: stringSeparator2)[0].replacingOccurrences(of: "&deg;", with: "°")
                    print(forecast)
                    DispatchQueue.main.sync(execute: {
                        self.forecastTextField.text = forecast
                    })
                }
            }
        }
        task.resume()
    }

}

