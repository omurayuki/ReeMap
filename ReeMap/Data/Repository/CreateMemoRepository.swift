import CoreLocation
import Foundation
import RxSwift

protocol CreateMemoRepositoryProtocol {
    
    func getPlacemarks(streetAddress: String) -> Single<CLPlacemark>
}

struct CreateMemoRepository: CreateMemoRepositoryProtocol {
    
    static let shared = CreateMemoRepository()
    
    func getPlacemarks(streetAddress: String) -> Single<CLPlacemark> {
        let dataStore = LocationDataStoreFactory.createLocationLocalDataStore()
        return dataStore.getPlacemarks(streetAddress: streetAddress)
    }
}
