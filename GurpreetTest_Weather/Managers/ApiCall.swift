import Foundation
import UIKit
import CoreLocation

class ApiCall: NSObject {
    static let shared = ApiCall()
    private override init() {}
    
    func getData(_ coordinates: CLLocationCoordinate2D,  completion: @escaping (Data?)->Void) {
        
        let latitude = "\(coordinates.latitude)",  longitude = "\(coordinates.longitude)"
        
        var request = URLRequest(url: URL(string: "https://community-open-weather-map.p.rapidapi.com/weather?q=&lat=\(latitude)&lon=\(longitude)")!,timeoutInterval: Double.infinity)
        request.addValue("pEdohuvbB5mshXWY4oIcVGcQTNwxp1G0VGVjsn5W5ad3zLXBYl", forHTTPHeaderField: "x-rapidapi-key")

        request.httpMethod = "GET"

        HudManager.shared.addLoader(nil)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
         
            DispatchQueue.main.async {
                HudManager.shared.removeLoader()
                if error != nil {
                    AlertManager.shared.show(GPAlert(title: "Error", message: error!.localizedDescription))
                }else{
                    completion(data)
                }
            }
        }

        task.resume()

    }
    
}
