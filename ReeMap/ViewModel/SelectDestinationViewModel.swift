import CoreLocation
import Foundation
import MapKit
import RxCocoa
import RxSwift

final class SelectDestinationViewModel: ViewModel {
    
    private let useCase: SelectDestinationUseCaseProtocol
    private var currentCoodinate = BehaviorRelay<CLLocation>(value: CLLocation())
    var streetAddress = String()
    var isInitialZoom = true
    var isFirstInput = true
    var currentLocation: CLLocation?
    var recieveAnnotationsHandler: (([Annotation]) -> Void)?
    
    var didRecieveAnnotations: [Annotation]? {
        didSet {
            guard let annotations = didRecieveAnnotations else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [unowned self] in
                self.recieveAnnotationsHandler?(annotations)
            }
        }
    }
    
    init(useCase: SelectDestinationUseCaseProtocol) {
        currentLocation = LocationService.sharedInstance.currentLocation
        self.useCase = useCase
    }
}

extension SelectDestinationViewModel {
    
    struct Input {
        
        var regionWillChangeAnimated: Observable<[Any]>
    }
    
    struct Output {
        
        var coodinatorConvertingSuccess: Observable<CLPlacemark>
        var coodinatorConvertingError: Observable<Error>
    }
    
    func transform(input: Input) -> Output {
        let coodinatorConverting = input.regionWillChangeAnimated
            .flatMap { value -> Observable<Event<CLPlacemark>> in
                guard let mapView = value[0] as? MKMapView else { return .empty() }
                self.currentCoodinate.accept(CLLocation(latitude: mapView.centerCoordinate.latitude,
                                                        longitude: mapView.centerCoordinate.longitude))
                return self.getPlacemarks(location: self.currentCoodinate.value)
                    .asObservable()
                    .materialize()
            }.share(replay: 1)
        
        return Output(coodinatorConvertingSuccess: coodinatorConverting.elements(),
                      coodinatorConvertingError: coodinatorConverting.errors())
    }
}

extension SelectDestinationViewModel {
    
    func getPlacemarks(location: CLLocation) -> Single<CLPlacemark> {
        return useCase.getPlacemarks(location: location)
    }
    
    func zoomTo(completion: (MKCoordinateRegion) -> Void) {
        if isInitialZoom {
            let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: currentLocation?.coordinate.latitude ?? 0.0,
                                                                           longitude: currentLocation?.coordinate.longitude ?? 0.0),
                                            latitudinalMeters: 300,
                                            longitudinalMeters: 300)
            completion(region)
            isInitialZoom = false
        }
    }
    
    func updateStreetAddress(placemark: CLPlacemark, completion: (String) -> Void) {
        guard
            let administrativeArea = placemark.administrativeArea,
            let locality = placemark.locality,
            let thoroughfare = placemark.thoroughfare,
            let subThoroughfare = placemark.subThoroughfare
        else { return }
        if isFirstInput { self.isFirstInput = false; return }
        let streetAddress = "\(administrativeArea)\(locality)\(thoroughfare)\(subThoroughfare)"
        self.streetAddress = streetAddress
        completion(streetAddress)
    }
    
    func validateIsCloseBetweenDistances(completion: (Bool) -> Void) {
        didRecieveAnnotations?.forEach { [unowned self] in
            let coodinate = CLLocation(latitude: $0.coordinate.latitude, longitude: $0.coordinate.longitude)
            if coodinate.distance(from: self.currentCoodinate.value) <= 70 {
                completion(true)
            }
        }
        completion(false)
    }
}
