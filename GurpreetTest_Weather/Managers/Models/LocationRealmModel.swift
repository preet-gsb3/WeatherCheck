import Foundation
import RealmSwift

class LocationRealmModel: Object {

    @objc dynamic var lng: String = ""
    @objc dynamic var lat: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var weatherData: String = ""
    @objc dynamic var created: String = ""

    override static func primaryKey() -> String? {
        return "created"
    }

}
