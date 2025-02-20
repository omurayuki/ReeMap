import CoreLocation
import Foundation
import RxSwift

protocol CreateMemoUseCaseProtocol {
    
    func getPlacemarks(streetAddress: String) -> Single<CLPlacemark>
    func setNote(_ note: EntityType) -> Single<()>
    func updateNote(_ note: EntityType, noteId: String) -> Single<()>
    func getUIDToken() -> String
}

struct CreateMemoUseCase: CreateMemoUseCaseProtocol {
    
    private(set) var repository: CreateMemoRepositoryProtocol
    
    init(repository: CreateMemoRepositoryProtocol) {
        self.repository = repository
    }
    
    func getPlacemarks(streetAddress: String) -> Single<CLPlacemark> {
        return repository.getPlacemarks(streetAddress: streetAddress)
    }
    
    func setNote(_ note: EntityType) -> Single<()> {
        return repository.setNote(note)
    }
    
    func updateNote(_ note: EntityType, noteId: String) -> Single<()> {
        return repository.updateNote(note, noteId: noteId)
    }
    
    func getUIDToken() -> String {
        return repository.getUIDToken()
    }
}
