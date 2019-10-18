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
        
        let switchNotification: Observable<[Any]>
    }
    
    struct Output {
        
        var notificationSuccess: Observable<()>
        var notificationError: Observable<Error>
    }
    
    func transform(input: Input) -> Output {
        let notification = input.switchNotification
            .flatMap { notifies -> Observable<Event<()>> in
                guard let notify = notifies[0] as? Int, let docId = notifies[1] as? String else { return .empty() }
                return self.updateNote([Constants.DictKey.notification: notify == 1 ? true : false], noteId: docId).asObservable().materialize()
            }.share(replay: 1)
        
        return Output(notificationSuccess: notification.elements(),
                      notificationError: notification.errors())
    }
}

extension NoteListViewModel {
    
    func updateNote(_ note: EntityType, noteId: String) -> Single<()> {
        return useCase.updateNote(note, noteId: noteId)
    }
    
    func deleteNote(place: Place) -> Single<()> {
        return useCase.deleteNote(place: place)
    }
}
