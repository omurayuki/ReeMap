import CoreLocation
import Foundation
import RxCocoa
import RxSwift

final class CreateMemoViewModel: ViewModel {
    
    private let useCase: CreateMemoUseCaseProtocol

    init(useCase: CreateMemoUseCaseProtocol) {
        self.useCase = useCase
    }
}

extension CreateMemoViewModel {
    
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    func transform(input: Input) -> Output {
        
        return Output()
    }
}

extension CreateMemoViewModel {
    
    func getPlacemarks(streetAddress: String) -> Single<CLPlacemark> {
        return useCase.getPlacemarks(streetAddress: streetAddress)
    }
}
