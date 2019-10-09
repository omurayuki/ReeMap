import CoreLocation
import Foundation
import RxCocoa
import RxSwift

final class EditNoteViewModel: ViewModel {
    
    private let useCase: CreateMemoUseCaseProtocol
    private var isLoading = BehaviorRelay<Bool>(value: false)
    
    init(useCase: CreateMemoUseCaseProtocol) {
        self.useCase = useCase
    }
}

extension EditNoteViewModel {
    
    struct Input {
        
    }
    
    struct Output {
        
        var isLoading: Driver<Bool>
    }
    
    func transform(input: Input) -> Output {
        
        return Output(isLoading: isLoading.asDriver())
    }
}

extension EditNoteViewModel {
    
    func getPlacemarks(streetAddress: String) -> Single<CLPlacemark> {
        return useCase.getPlacemarks(streetAddress: streetAddress)
    }
    
    func updateNote(_ note: EntityType, noteId: String) -> Single<()> {
        return useCase.updateNote(note, noteId: noteId)
    }
    
    func updateLoading(_ loading: Bool) {
        isLoading.accept(loading)
    }
}
