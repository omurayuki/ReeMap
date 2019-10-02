import Foundation

struct MapDataStoreFactory {
    
    static func createMapRemoteDataStore() -> MapRemoteDataStoreProtocol {
        return MapRemoteDataStore()
    }
}
