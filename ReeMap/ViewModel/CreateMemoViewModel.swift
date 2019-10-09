import CoreLocation
import Foundation
import RxCocoa
import RxSwift

final class CreateMemoViewModel: ViewModel {
    
    private let useCase: CreateMemoUseCaseProtocol
    private var isLoading = BehaviorRelay<Bool>(value: false)

    init(useCase: CreateMemoUseCaseProtocol) {
        self.useCase = useCase
    }
}

extension CreateMemoViewModel {
    
    struct Input {
        
    }
    
    struct Output {
        
        var isLoading: Driver<Bool>
    }
    
    func transform(input: Input) -> Output {
        
        return Output(isLoading: isLoading.asDriver())
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
}
