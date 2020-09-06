//
//  WeatherViewController.swift
//  GurpreetTest_Weather
//
//  Created by Gurpreet Singh on 06/09/20.
//  Copyright © 2020 Gurpreet Singh. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {

    @IBOutlet weak var lblInfo: UILabel!
    
    var coordinates: CLLocationCoordinate2D!
    var weatherData: WeatherResponseModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let arrWeather = weatherData.weather {
            if let dataAtIndex = arrWeather.first {
                let main = dataAtIndex.main ?? ""
                let desc = dataAtIndex.weatherDescription ?? ""
                
                if let mainData = weatherData.main {
                    
                    let temp = "\(mainData.temp ?? 0)"
                    let mintemp = "\(mainData.tempMin ?? 0)"
                    let maxtemp = "\(mainData.tempMax ?? 0)"
                    let humidity = "\(mainData.humidity ?? 0)"

                    lblInfo.text = "\(main) - \(desc)\n\nTemp: \(temp)\nMin Temp: \(mintemp)\nMax Temp: \(maxtemp)\n Humidity: \(humidity)"
                }
                
            }
        }
        
    }
    
    @IBAction func btnBack(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
