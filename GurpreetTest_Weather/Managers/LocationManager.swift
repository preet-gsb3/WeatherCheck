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
            viewRegion.span.latitudeDelta = 2
            viewRegion.span.longitudeDelta = 2
            mapView.setRegion(viewRegion, animated: false)
        }
    }
    
    func storeLocalDataForLocationWeather(_ coordinate: CLLocationCoordinate2D, modelData: WeatherResponseModel, completion: @escaping (String)->Void) {
        
        var weatherInfo = ""
        if let arrWeather = modelData.weather {
            if let dataAtIndex = arrWeather.first {
                let main = dataAtIndex.main ?? ""
                let desc = dataAtIndex.weatherDescription ?? ""
                
                if let mainData = modelData.main {
                    
                    let temp = "\(mainData.temp ?? 0)"
                    let mintemp = "\(mainData.tempMin ?? 0)"
                    let maxtemp = "\(mainData.tempMax ?? 0)"
                    let humidity = "\(mainData.humidity ?? 0)"

                    weatherInfo = "\(main) - \(desc)\n\nTemp: \(temp)\nMin Temp: \(mintemp)\nMax Temp: \(maxtemp)\n Humidity: \(humidity)"
                }
            }
        }
        
        let realmModel = LocationRealmModel()
        realmModel.lat = "\(coordinate.latitude)"
        realmModel.lng = "\(coordinate.longitude)"
        realmModel.weatherData = weatherInfo
        let timestamp = Date().toTimeStamp()
        realmModel.created = timestamp
        RealmManager.shared.save(realmModel)
        
        
        // Update Place Name
        LocationManager.shared.fetchPlaceName(coordinate) {
            (address) in
            let objDatabase = uiRealm.objects(LocationRealmModel.self).filter({$0.created == timestamp})
            if let dataAtIndex = objDatabase.first {
                do{
                    try uiRealm.safeWrite {
                        dataAtIndex.name = address
                    }
                }catch{
                    print(error)
                }
            }
        }
                   
        completion(timestamp)
        
    }
    
    func fetchPlaceName(_ coordinates: CLLocationCoordinate2D, completion: @escaping (String)->Void) {
        // Add below code to get address for touch coordinates.
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
        geoCoder.reverseGeocodeLocation(location, completionHandler:
            {
                placemarks, error -> Void in
                
                // Place details
                guard let placeMark = placemarks?.first else { return }
                var address = ""
                
                // Location name
                if let locationName = placeMark.location {
                    print(locationName)
                }
                // Street address
                if let street = placeMark.thoroughfare {
                    address = address + street + ", "
                }
                // City
                if let city = placeMark.subAdministrativeArea {
                    address = address + city + ", "
                }
                
                // Country
                if let country = placeMark.country {
                    address = address + country
                }
                
                // Zip code
                if let zip = placeMark.isoCountryCode {
                    address = address + " - " + zip
                }
                
                completion(address)
        })
        
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
