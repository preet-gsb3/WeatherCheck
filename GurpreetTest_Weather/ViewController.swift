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
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        mapView.isUserInteractionEnabled = true
        gestureRecognizer.minimumPressDuration = 2
        gestureRecognizer.numberOfTouchesRequired = 1
        mapView.addGestureRecognizer(gestureRecognizer)
        
        let objDatabase = uiRealm.objects(LocationRealmModel.self)
        
        for data in objDatabase {
            let annotation = MyAnnotation()
            let latitude = (data.lat as NSString).doubleValue
            let longitude = (data.lng as NSString).doubleValue
            annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            annotation.id = data.created
            mapView.addAnnotation(annotation)
        }
        
    }

    @objc func handleTap(_ gestureRecognizer: UILongPressGestureRecognizer) {

        if (gestureRecognizer.state == .ended){
           return
        }
        
        let location = gestureRecognizer.location(in: mapView)
        let coordinate = mapView.convert(location, toCoordinateFrom: mapView)

        // Add annotation:
        let annotation = MyAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
        
        ApiCall.shared.getData(coordinate) { (responseData) in
            if let responseData = responseData {
                let responseModel = WeatherResponseModel.decode(responseData)

                LocationManager.shared.storeLocalDataForLocationWeather(coordinate, modelData: responseModel) {
                    (timestampKey) in
                    annotation.id = timestampKey
                    let vc = self.storyboard?.instantiateViewController(identifier: "WeatherViewController") as! WeatherViewController
                    vc.timestampKey = timestampKey
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
}

extension ViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation as? MyAnnotation, let timestampKey = annotation.id {
            let vc = self.storyboard?.instantiateViewController(identifier: "WeatherViewController") as! WeatherViewController
            vc.timestampKey = timestampKey
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

class MyAnnotation: MKPointAnnotation{
    var id: String!
    var name: String?
}
