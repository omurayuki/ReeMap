import CoreLocation
import Foundation
import RxCocoa
import RxSwift

final class SelectDestinationViewModel: ViewModel {
    
    private let useCase: SelectDestinationUseCaseProtocol
    
    init(useCase: SelectDestinationUseCaseProtocol) {
        self.useCase = useCase
    }
}

extension SelectDestinationViewModel {
    
    struct Input {
    }
    
    struct Output {
    }
    
    func transform(input: Input) -> Output {
        return Output()
    }
}

extension SelectDestinationViewModel {
    
    func getPlacemarks(location: CLLocation) -> Single<CLPlacemark> {
        return useCase.getPlacemarks(location: location)
    }
}
