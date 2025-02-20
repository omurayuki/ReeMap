import CoreLocation
import FirebaseFirestore
import Foundation
import RxCocoa
import RxSwift

final class CreateMemoViewModel: ViewModel {
    
    private let useCase: CreateMemoUseCaseProtocol
    private var isLoading = BehaviorRelay<Bool>(value: false)
    private var isSaveBtnEnable = BehaviorRelay<Bool>(value: false)
    private var memoTextView = BehaviorRelay<String>(value: "")
    var didRecieveStreetAddress: String?

    init(useCase: CreateMemoUseCaseProtocol) {
        self.useCase = useCase
    }
}

extension CreateMemoViewModel {
    
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
                return self.setNote(self.createEntity(latitude: placemark.location?.coordinate.latitude ?? 0.0,
                                                      longitude: placemark.location?.coordinate.longitude ?? 0.0))
                    .asObservable()
                    .materialize()
            }.share(replay: 1)
        
        return Output(isLoading: isLoading.asDriver(),
                      isSaveBtnEnable: isSaveBtnEnable.asDriver(),
                      noteSaveSuccess: noteSavedAttribute.elements(),
                      noteSaveError: noteSavedAttribute.errors())
    }
}

extension CreateMemoViewModel {
    
    func getPlacemarks(streetAddress: String) -> Single<CLPlacemark> {
        return useCase.getPlacemarks(streetAddress: streetAddress)
    }
    
    func setNote(_ note: EntityType) -> Single<()> {
        return useCase.setNote(note)
    }
    
    func getUIDToken() -> String {
        return useCase.getUIDToken()
    }
    
    func updateLoading(_ loading: Bool) {
        isLoading.accept(loading)
    }
    
    func setSaveBtnEnable(_ bool: Bool) {
        isSaveBtnEnable.accept(bool)
    }
    
    func setMemoTextView(_ text: String) {
        memoTextView.accept(text)
    }
    
    private func createEntity(latitude: Double, longitude: Double) -> EntityType {
        return [
            Constants.DictKey.uid: getUIDToken(),
            Constants.DictKey.createdAt: FieldValue.serverTimestamp(),
            Constants.DictKey.updatedAt: FieldValue.serverTimestamp(),
            Constants.DictKey.content: memoTextView.value,
            Constants.DictKey.notification: true,
            Constants.DictKey.streetAddress: didRecieveStreetAddress ?? "",
            Constants.DictKey.geoPoint: GeoPoint(latitude: latitude, longitude: longitude)
        ]
    }
}
