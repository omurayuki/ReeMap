import Foundation

struct SelectDestinationDataStoreFactory {
    
    static func createSelectDestinationLocalDataStore() -> SelectDestinationLocalDataStoreProtocol {
        return SelectDestinationLocalDataStore()
    }
}
