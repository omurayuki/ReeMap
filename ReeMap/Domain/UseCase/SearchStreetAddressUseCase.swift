import CoreLocation
import Foundation
import MapKit
import RxSwift

protocol SearchStreetAddressUseCaseProtocol {
    
    func acquisitionSearchedResult(query: String, location: CLLocation) -> Single<[MKMapItem]>
}

struct SearchStreetAddressUseCase: SearchStreetAddressUseCaseProtocol {
    
    private(set) var repository: SearchStreetAddressRepositoryProtocol
    
    init(repository: SearchStreetAddressRepositoryProtocol) {
        self.repository = repository
    }
    
    func acquisitionSearchedResult(query: String, location: CLLocation) -> Single<[MKMapItem]> {
        return repository.acquisitionSearchedResult(query: query, location: location)
    }
}
