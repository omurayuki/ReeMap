import CoreLocation
import Foundation
import RxSwift

protocol NoteListUseCaseProtocol {
    
    func getPlacemarks(location: CLLocation) -> Single<CLPlacemark>
    func updateNote(_ note: EntityType, noteId: String) -> Single<()>
    func deleteNote(place: Place) -> Single<()>
}

struct NoteListUseCase: NoteListUseCaseProtocol {
    
    private(set) var repository: NoteListRepositoryProtocol
    
    init(repository: NoteListRepositoryProtocol) {
        self.repository = repository
    }
    
    func getPlacemarks(location: CLLocation) -> Single<CLPlacemark> {
        return repository.getPlacemarks(location: location)
    }
    
    func updateNote(_ note: EntityType, noteId: String) -> Single<()> {
        return repository.updateNote(note, noteId: noteId)
    }
    
    func deleteNote(place: Place) -> Single<()> {
        return repository.deleteNote(place: place)
    }
}
