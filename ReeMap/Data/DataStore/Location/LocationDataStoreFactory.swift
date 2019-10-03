import Foundation

struct LocationDataStoreFactory {
    
    static func createLocationLocalDataStore() -> LocationLocalDataStoreProtocol {
        return LocationLocalDataStore()
    }
}
