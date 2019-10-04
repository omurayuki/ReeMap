import CoreLocation
import Foundation
import MapKit
import RxCocoa
import RxSwift

final class SearchStreetAddressViewModel: ViewModel {
    
    private let useCase: SearchStreetAddressUseCaseProtocol

    init(useCase: SearchStreetAddressUseCaseProtocol) {
        self.useCase = useCase
    }
}

extension SearchStreetAddressViewModel {
    
    struct Input {
    }
    
    struct Output {
    }
    
    func transform(input: Input) -> Output {
        return Output()
    }
}

extension SearchStreetAddressViewModel {
    
    func acquisitionSearchedResult(query: String, location: CLLocation) -> Single<[MKMapItem]> {
        return useCase.acquisitionSearchedResult(query: query, location: location)
    }
}
