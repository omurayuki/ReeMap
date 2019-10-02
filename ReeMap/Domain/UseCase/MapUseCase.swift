import Foundation
import RxSwift

protocol MapUseCaseProtocol {
    
    func AuthenticateAnonymous() -> Single<User>
    func fetchMemos() -> Observable<[Place]>
}

struct MapUseCase: MapUseCaseProtocol {
    
    private(set) var repository: MapRepositoryProtocol
    
    init(repository: MapRepositoryProtocol) {
        self.repository = repository
    }
    
    func AuthenticateAnonymous() -> Single<User> {
        return repository.AuthenticateAnonymous().map { AuthTranslator().translate($0) }
    }
    
    func fetchMemos() -> Observable<[Place]> {
        return repository.fetchMemos().map { MapsTranslator().translate($0) }
    }
}
