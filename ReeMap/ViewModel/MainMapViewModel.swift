import CoreLocation
import Foundation
import MapKit
import RxCocoa
import RxSwift

final class MainMapViewModel: ViewModel {
    
    private let useCase: MapUseCaseProtocol
    
    private var initialZoom = BehaviorRelay<Bool>(value: false)
    private var zooming = BehaviorRelay<Bool?>(value: nil)
    private var blockingAutoZoom = BehaviorRelay<Bool?>(value: nil)
    private var zoomBlockingTimer = BehaviorRelay<Timer?>(value: nil)
    
    private var annotations = BehaviorRelay<[Annotation]>(value: [])
    private var currentLocation = BehaviorRelay<CLLocation>(value: CLLocation(latitude: 0, longitude: 0))
    
    init(useCase: MapUseCaseProtocol) {
        self.useCase = useCase
    }
}

extension MainMapViewModel {
    
    struct Input {
        
        let viewWillAppear: Observable<[Any]>
    }
    
    struct Output {
        
        let places: Observable<[Place]>
        let error: Observable<Error>
        var didAnnotationFetched: Observable<[Annotation]>
        var didLocationUpdated: Observable<CLLocation>
    }
    
    func transform(input: Input) -> Output {
        let places = input.viewWillAppear
            .flatMap { [unowned self] _ -> Observable<Event<[Place]>> in
                self.useCase.fetchMemos()
                    .do(onNext: { [unowned self] places in
                        self.annotations
                            .accept(places.compactMap { Annotation(content: $0.content,
                                                                   coordinate: CLLocationCoordinate2D(latitude: $0.latitude,
                                                                                                      longitude: $0.longitude))
                            })
                    }).materialize()
            }.share(replay: 1)
        
        return Output(places: places.elements(),
                      error: places.errors(),
                      didAnnotationFetched: annotations.compactMap { $0 },
                      didLocationUpdated: currentLocation.asObservable())
    }
}

extension MainMapViewModel {
    
    func AuthenticateAnonymous() -> Single<User> {
        return useCase.AuthenticateAnonymous()
    }
    
    func getUIDToken() -> Observable<String> {
        return useCase.getUIDToken().asObservable()
            .materialize()
            .elements()
    }
    
    func setUIDToken(_ token: String) {
        useCase.setUIDToken(token)
    }
    
    func updateLocation(_ location: CLLocation) {
        currentLocation.accept(location)
    }
    
    func zoomTo(location: CLLocation, left: () -> Void, right: () -> Void) {
        if initialZoom.value == false {
            left()
            initialZoom.accept(true)
        }
        if blockingAutoZoom.value == false {
            zooming.accept(true)
            right()
        }
    }
    
    func changeZoomState() {
        if zooming.value == true {
            zooming.accept(false)
            blockingAutoZoom.accept(false)
        } else {
            blockingAutoZoom.accept(true)
            guard let timer = zoomBlockingTimer.value else { return }
            if timer.isValid { timer.invalidate() }
            zoomBlockingTimer.accept(.scheduledTimer(withTimeInterval: 10.0,
                                                     repeats: false,
                                                     block: { [unowned self] _ in
                self.zoomBlockingTimer.accept(nil)
                self.blockingAutoZoom.accept(false)
            }))
        }
    }
    
    func compareCoodinate() {
        var value = CLLocationDistance()
        var value2 = CLLocationDistance()
        annotations.value.forEach { annotation in
            value = currentLocation.value.coordinate.latitude.distance(to: annotation.coordinate.latitude)
            value2 = annotation.coordinate.latitude - currentLocation.value.coordinate.latitude
            print(value == value2)
        }
    }
}
