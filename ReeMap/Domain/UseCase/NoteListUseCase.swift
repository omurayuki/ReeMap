import CoreLocation
import Foundation
import RxSwift

protocol NoteListUseCaseProtocol {
    
    func getPlacemarks(location: CLLocation) -> Single<CLPlacemark>
}

struct NoteListUseCase: NoteListUseCaseProtocol {
    
    private(set) var repository: NoteListRepositoryProtocol
    
    init(repository: NoteListRepositoryProtocol) {
        self.repository = repository
    }
    
    func getPlacemarks(location: CLLocation) -> Single<CLPlacemark> {
        return repository.getPlacemarks(location: location)
    }
}
