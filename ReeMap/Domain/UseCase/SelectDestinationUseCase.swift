import CoreLocation
import Foundation
import RxSwift

protocol SelectDestinationUseCaseProtocol {
    
    func getPlacemarks(location: CLLocation) -> Single<CLPlacemark>
}

struct SelectDestinationUseCase: SelectDestinationUseCaseProtocol {
    
    private(set) var repository: SelectDestinationRepositoryProtocol
    
    init(repository: SelectDestinationRepositoryProtocol) {
        self.repository = repository
    }
    
    func getPlacemarks(location: CLLocation) -> Single<CLPlacemark> {
        return repository.getPlacemarks(location: location)
    }
}
