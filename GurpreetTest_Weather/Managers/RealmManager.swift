import Foundation
import RealmSwift
import Realm

extension Realm {
    public func safeWrite(_ block: (() throws -> Void)) throws {
        if isInWriteTransaction {
            try block()
        } else {
            try write(block)
        }
    }
    
    func writeAsync<T : ThreadConfined>(obj: T, errorHandler: @escaping ((_ error : Swift.Error) -> Void) = { _ in return }, block: @escaping ((Realm, T?) -> Void)) {
        let wrappedObj = ThreadSafeReference(to: obj)
        let config = self.configuration
        DispatchQueue(label: "background").async {
            autoreleasepool {
                do {
                    let realm = try Realm(configuration: config)
                    let obj = realm.resolve(wrappedObj)

                    try realm.safeWrite {
                        block(realm, obj)
                    }
                }
                catch {
                    errorHandler(error)
                    print(error.localizedDescription)
                }
            }
        }
    }
    
}

class RealmManager: NSObject {
    static let shared = RealmManager()
    private override init() {}
    
    func setConfiguration() {
        let configuration = Realm.Configuration(
            schemaVersion: 2,
            migrationBlock: { migration, oldSchemaVersion in
                if oldSchemaVersion < 1 {
                    
                }
        }, shouldCompactOnLaunch: { totalBytes, usedBytes in
            // totalBytes refers to the size of the file on disk in bytes (data + free space)
            // usedBytes refers to the number of bytes used by data in the file
            
            // Compact if the file is over 100MB in size and less than 50% 'used'
            let oneHundredMB = 100 * 1024 * 1024
            return (totalBytes > oneHundredMB) && (Double(usedBytes) / Double(totalBytes)) < 0.5
        })
        do {
            // Realm is compacted on the first open if the configuration block conditions were met.
            _ = try Realm(configuration: configuration)
        } catch {
            // handle error compacting or opening Realm
        }
        
        Realm.Configuration.defaultConfiguration = configuration
    }
    
    func save(_ object: Object) {
        do {
            try uiRealm.safeWrite {
                uiRealm.add(object)
            }
        }catch {
            print(error.localizedDescription)
        }
    }
    
    func deleteObject(in result: Object) {
        do {
            try uiRealm.safeWrite {
                uiRealm.delete(result)
            }
        }catch {
            print(error.localizedDescription)
        }
    }
    
    func findPath() {
        print("Realm Path: ", try! Realm().configuration.fileURL?.absoluteString ?? "")
    }
    
}
