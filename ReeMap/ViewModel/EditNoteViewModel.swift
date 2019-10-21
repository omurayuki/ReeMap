import CoreLocation
import FirebaseFirestore
import Foundation
import RxCocoa
import RxSwift

final class EditNoteViewModel: ViewModel {
    
    private let useCase: CreateMemoUseCaseProtocol
    private var isLoading = BehaviorRelay<Bool>(value: false)
    private var isSaveBtnEnable = BehaviorRelay<Bool>(value: false)
    private var noteTextData = BehaviorRelay<String>(value: "")
    var streetAddressRecieveHandler: ((String) -> Void)?
    var noteRecieveHandler: ((String) -> Void)?
    var didRecieveNoteId: String!
    
    var didRecieveStreetAddress: String? {
        didSet {
            guard let streetAddreee = didRecieveStreetAddress else { return }
            streetAddressRecieveHandler?(streetAddreee)
        }
    }
    
    var didRecieveNote: String? {
        didSet {
            guard let note = didRecieveNote else { return }
            noteRecieveHandler?(note)
        }
    }
    
    init(useCase: CreateMemoUseCaseProtocol) {
        self.useCase = useCase
    }
}

extension EditNoteViewModel {
    
    struct Input {
        
        let saveBtnTapped: Observable<Void>
    }
    
    struct Output {
        
        var isLoading: Driver<Bool>
        var isSaveBtnEnable: Driver<Bool>
        var noteSaveSuccess: Observable<()>
        var noteSaveError: Observable<Error>
    }
    
    func transform(input: Input) -> Output {
        let noteSavedAttribute = input.saveBtnTapped
            .flatMap { [unowned self] _ -> Observable<CLPlacemark> in
                self.getPlacemarks(streetAddress: self.didRecieveStreetAddress ?? "").asObservable()
            }.flatMap { placemark -> Observable<Event<()>> in
                self.updateLoading(true)
                self.setSaveBtnEnable(false)
                return self.updateNote(self.createEntity(latitude: placemark.location?.coordinate.latitude ?? 0.0,
                                                         longitude: placemark.location?.coordinate.longitude ?? 0.0),
                                       noteId: self.didRecieveNoteId ?? "")
                    .asObservable()
                    .materialize()
            }.share(replay: 1)
        
        return Output(isLoading: isLoading.asDriver(),
                      isSaveBtnEnable: isSaveBtnEnable.asDriver(),
                      noteSaveSuccess: noteSavedAttribute.elements(),
                      noteSaveError: noteSavedAttribute.errors())
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
    
    func setSaveBtnEnable(_ bool: Bool) {
        isSaveBtnEnable.accept(bool)
    }
    
    func setTextData(_ text: String) {
        noteTextData.accept(text)
    }
    
    private func createEntity(latitude: Double, longitude: Double) -> EntityType {
        return [Constants.DictKey.updatedAt: FieldValue.serverTimestamp(),
                Constants.DictKey.content: noteTextData.value,
                Constants.DictKey.notification: true,
                Constants.DictKey.geoPoint: GeoPoint(latitude: latitude,
                                                     longitude: longitude)]
    }
}
