import CoreLocation
import Foundation
import RxCocoa
import RxSwift

final class NoteListViewModel: ViewModel {
    
    private let useCase: NoteListUseCaseProtocol
    
    init(useCase: NoteListUseCaseProtocol) {
        self.useCase = useCase
    }
}

extension NoteListViewModel {
    
    struct Input {
    }
    
    struct Output {
    }
    
    func transform(input: Input) -> Output {
        return Output()
    }
}

extension NoteListViewModel {
    
    func getPlacemarks(location: CLLocation) -> Single<CLPlacemark> {
        return useCase.getPlacemarks(location: location)
    }
}
