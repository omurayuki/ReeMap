import Foundation
import RxSwift

protocol MapUseCaseProtocol {
    
    func fetchMemos() -> Observable<[Place]>
}

struct MapUseCase: MapUseCaseProtocol {
    
    private(set) var repository: MapRepositoryProtocol
    
    init(repository: MapRepositoryProtocol) {
        self.repository = repository
    }
    
    func fetchMemos() -> Observable<[Place]> {
        return repository.fetchMemos().map { MapsTranslator().translate($0) }
    }
}
