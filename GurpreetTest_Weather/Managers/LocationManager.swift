import Foundation
import UIKit
import CoreLocation
import MapKit

class LocationManager: NSObject {
    static let shared = LocationManager()
    private override init() {}
    
    typealias CompletionHandler = (Bool)->Void
    var PermisionHandler: CompletionHandler?
    
    private var currentLocation: CLLocation!
    private let locationManager = CLLocationManager()
    private var mapView: MKMapView!
    
    func setup(_ mapView: MKMapView, permissionStatus: CompletionHandler? = {_ in}) {
        
        self.PermisionHandler = permissionStatus
        self.mapView = mapView
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()

    }
    
    private func setupCoreLocation() {
        
        // Check for Location Services
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager.requestWhenInUseAuthorization()
        }

        DispatchQueue.main.async {
            self.locationManager.startUpdatingLocation()
        }
    }
    
    private func setupCurrentRegion() {
        self.mapView.showsUserLocation = true

        if let currentLocation = self.currentLocation {
            var viewRegion = MKCoordinateRegion()
            viewRegion.center = currentLocation.coordinate
            viewRegion.span.latitudeDelta = 1
            viewRegion.span.longitudeDelta = 1
            mapView.setRegion(viewRegion, animated: false)
        }
    }
    
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if self.currentLocation == nil {
            self.currentLocation = locations.last
            self.setupCurrentRegion()
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
        case .restricted, .denied:
            if self.PermisionHandler != nil {
                PermisionHandler!(false)
            }
            // Disable your app's location features
            AlertManager.shared.show(AppConstants.Alert.locationPermission(), buttonsArray: ["Close","Go To Settings"], completionBlock: { (index : Int) in
                switch index{
                case 0:
                    break
                case 1:
                    UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
                    break
                default:
                    //print("-:Something Wrong")
                    break
                }
            })
            break
            
        case .authorizedWhenInUse:
            // Enable only your app's when-in-use features.
            if self.PermisionHandler != nil {
                PermisionHandler!(true)
            }
            self.setupCoreLocation()
            break
            
        case .authorizedAlways:
            // Enable only your app's always features.
            if self.PermisionHandler != nil {
                PermisionHandler!(true)
            }
            self.setupCoreLocation()
            break
            
        case .notDetermined:
            if self.PermisionHandler != nil {
                PermisionHandler!(false)
            }
            break
            
        default:
            break
        }
        
    }
    
}
