//
//  ViewController.swift
//  GurpreetTest_Weather
//
//  Created by Gurpreet Singh on 06/09/20.
//  Copyright © 2020 Gurpreet Singh. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup Location Manager
        LocationManager.shared.setup(self.mapView)
        
        mapView.delegate = self
        // Setup Map Double Tap gesture
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        mapView.isUserInteractionEnabled = true
        gestureRecognizer.numberOfTapsRequired = 1
        gestureRecognizer.numberOfTouchesRequired = 1
        mapView.addGestureRecognizer(gestureRecognizer)
        
    }

    @objc func handleTap(_ gestureRecognizer: UILongPressGestureRecognizer) {

        let location = gestureRecognizer.location(in: mapView)
        let coordinate = mapView.convert(location, toCoordinateFrom: mapView)

        // Add annotation:
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
        
        ApiCall.shared.getData(coordinate) { (responseData) in
            if let responseData = responseData {
                let responseModel = WeatherResponseModel.decode(responseData)
                
                let vc = self.storyboard?.instantiateViewController(identifier: "WeatherViewController") as! WeatherViewController
                vc.weatherData = responseModel
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
        
        
    }
    
}

extension ViewController: MKMapViewDelegate {
    
    
    
}
