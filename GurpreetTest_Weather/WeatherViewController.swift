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
    
    var timestampKey  = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let objDatabase = uiRealm.objects(LocationRealmModel.self).filter({$0.created == self.timestampKey})
        if let dataAtIndex = objDatabase.first {
            
            var placeName = ""
            if !dataAtIndex.name.isEmpty {
                placeName = dataAtIndex.name + "\n\n"
            }
            
            self.lblInfo.text = placeName + dataAtIndex.weatherData
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
