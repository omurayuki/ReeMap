import CoreLocation
import Foundation
import RxSwift

protocol CreateMemoUseCaseProtocol {
    
    func getPlacemarks(streetAddress: String) -> Single<CLPlacemark>
}

struct CreateMemoUseCase: CreateMemoUseCaseProtocol {
    
    private(set) var repository: CreateMemoRepositoryProtocol
    
    init(repository: CreateMemoRepositoryProtocol) {
        self.repository = repository
    }
    
    func getPlacemarks(streetAddress: String) -> Single<CLPlacemark> {
        return repository.getPlacemarks(streetAddress: streetAddress)
    }
}
