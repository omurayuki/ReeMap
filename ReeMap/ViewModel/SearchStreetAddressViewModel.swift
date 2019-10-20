import CoreLocation
import Foundation
import MapKit
import RxCocoa
import RxSwift

final class SearchStreetAddressViewModel: ViewModel {
    
    private let useCase: SearchStreetAddressUseCaseProtocol
    private var location = BehaviorRelay<CLLocation>(value: CLLocation())

    init(useCase: SearchStreetAddressUseCaseProtocol) {
        self.useCase = useCase
    }
}

extension SearchStreetAddressViewModel {
    
    struct Input {
        
        let updateText: Observable<String>
    }
    
    struct Output {
        
        var searchResultSuccess: Observable<[MKMapItem]>
        var searchResultError: Observable<Error>
        var isSearchFieldEmpty: Observable<Bool>
    }
    
    func transform(input: Input) -> Output {
        let searchResult = input.updateText
            .flatMap { text -> Observable<Event<[MKMapItem]>> in
                guard !text.isEmpty else { return .empty() }
                return self.acquisitionSearchedResult(query: text, location: self.location.value)
                    .asObservable()
                    .materialize()
            }.share(replay: 1)
        
        let isSearchFieldEmpty = input.updateText
            .flatMap { text -> Observable<Bool> in
                Observable.of(text.isEmpty)
            }.share(replay: 1)
        
        return Output(searchResultSuccess: searchResult.elements(),
                      searchResultError: searchResult.errors(),
                      isSearchFieldEmpty: isSearchFieldEmpty)
    }
}

extension SearchStreetAddressViewModel {
    
    func acquisitionSearchedResult(query: String, location: CLLocation) -> Single<[MKMapItem]> {
        return useCase.acquisitionSearchedResult(query: query, location: location)
    }
    
    func setLocation(_ location: CLLocation) {
        self.location.accept(location)
    }
}
