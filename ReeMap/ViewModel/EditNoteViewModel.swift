import CoreLocation
import Foundation
import RxCocoa
import RxSwift

final class EditNoteViewModel: ViewModel {
    
    private let useCase: CreateMemoUseCaseProtocol
    
    init(useCase: CreateMemoUseCaseProtocol) {
        self.useCase = useCase
    }
}

extension EditNoteViewModel {
    
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    func transform(input: Input) -> Output {
        
        return Output()
    }
}

extension EditNoteViewModel {
    
    func getPlacemarks(streetAddress: String) -> Single<CLPlacemark> {
        return useCase.getPlacemarks(streetAddress: streetAddress)
    }
    
    func updateNote(_ note: EntityType, noteId: String) -> Single<()> {
        return useCase.updateNote(note, noteId: noteId)
    }
}
