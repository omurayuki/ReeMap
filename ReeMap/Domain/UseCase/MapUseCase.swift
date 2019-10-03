import CoreLocation
import Foundation
import RxSwift

protocol MapUseCaseProtocol {
    
    func AuthenticateAnonymous() -> Single<User>
    func fetchNotes() -> Observable<[Place]>
    func getPlacemarks(location: CLLocation) -> Single<CLPlacemark>
    func getUIDToken() -> String
    func setUIDToken(_ token: String)
}

struct MapUseCase: MapUseCaseProtocol {
    
    private(set) var repository: MapRepositoryProtocol
    
    init(repository: MapRepositoryProtocol) {
        self.repository = repository
    }
    
    func AuthenticateAnonymous() -> Single<User> {
        return repository.AuthenticateAnonymous().map { AuthTranslator().translate($0) }
    }
    
    func fetchNotes() -> Observable<[Place]> {
        return repository.fetchNotes().map { MapsTranslator().translate($0) }
    }
    
    func getPlacemarks(location: CLLocation) -> Single<CLPlacemark> {
        return repository.getPlacemarks(location: location)
    }
    
    func getUIDToken() -> String {
        return repository.getUIDToken()
    }
    
    func setUIDToken(_ token: String) {
        return repository.setUIDToken(token)
    }
}
