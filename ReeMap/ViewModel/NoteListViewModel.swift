import CoreLocation
import Foundation
import RxCocoa
import RxSwift

final class NoteListViewModel: ViewModel {
    
    var places: [Place]?
    var placesForDeletion: [Place]?
    var searchResultPlaces: [Place]?
    var placeForEditing: (note: String, address: String, noteId: String)?
    var placeAcceptHandler: (([Place]) -> Void)?
    
    var didAcceptPlaces: [Place]? {
        didSet {
            guard let places = didAcceptPlaces else { return }
            placeAcceptHandler?(places)
        }
    }
    
    private let useCase: NoteListUseCaseProtocol
    
    init(useCase: NoteListUseCaseProtocol) {
        self.useCase = useCase
    }
}

extension NoteListViewModel {
    
    struct Input {
        
        let switchNotification: Observable<[Any]>
        let deleteRows: Observable<[Any]>
    }
    
    struct Output {
        
        var notificationSuccess: Observable<()>
        var notificationError: Observable<Error>
        var deleteSuccess: Observable<()>
        var deleteError: Observable<Error>
    }
    
    func transform(input: Input) -> Output {
        let notification = input.switchNotification
            .flatMap { notifies -> Observable<Event<()>> in
                guard let notify = notifies[0] as? Int, let docId = notifies[1] as? String else { return .empty() }
                return self.updateNote([Constants.DictKey.notification: notify == 1 ? true : false], noteId: docId)
                    .asObservable()
                    .materialize()
            }.share(replay: 1)
        
        let cellDelete = input.deleteRows
            .flatMap { indexPath -> Observable<Event<()>> in
                guard let indexPath = indexPath[0] as? IndexPath else { return .empty() }
                guard let places = self.placesForDeletion else { return .empty() }
                return self.deleteNote(place: places[indexPath.row])
                    .asObservable()
                    .materialize()
            }.share(replay: 1)
        
        return Output(notificationSuccess: notification.elements(),
                      notificationError: notification.errors(),
                      deleteSuccess: cellDelete.elements(),
                      deleteError: cellDelete.errors())
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
