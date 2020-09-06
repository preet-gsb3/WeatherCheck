import UIKit

struct AppConstants {
    
    struct UserDefaults {
        static let kCacheWeather : String = "kCacheWeather"
    }
    
    struct Alert {
        static func locationPermission() -> GPAlert {
            let kPermissionMessage = "We need to have access to your Current Location to show you to Weather.\nPlease go to the App Settings and allow Location."
            return GPAlert(title: "Change your Settings", message: kPermissionMessage)
        }
    
    }
}

