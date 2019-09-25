import Foundation

struct MapDataStoreFactory {
    
    static func createMapRemoteDataStore() -> MapRemoteDataStore {
        return MapRemoteDataStore()
    }
}
