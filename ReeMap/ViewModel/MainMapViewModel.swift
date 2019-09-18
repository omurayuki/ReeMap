import CoreLocation
import Foundation
import RxCocoa
import RxSwift

protocol MainMapViewModelInput {
    
    func setIsInitialZoom(_ bool: Bool)
    func setIsBlockingAutoZoom(_ bool: Bool)
    func setIsZoom(_ bool: Bool)
    func setZoomBlockingTimer(_ timer: Timer?)
}

protocol MainMapViewModelOutput {
    
    func isBlockingAutoZoom() -> Bool
    func isZoom() -> Bool
    func getZoomBlockingTimer() -> Timer
    func zoomTo(location: CLLocation, left: () -> Void, right: () -> Void)
}

protocol MainMapViewModelType: ViewModel {
    
    var inputs: MainMapViewModelInput { get }
    var outputs: MainMapViewModelOutput { get }
}

struct MainMapViewModel: MainMapViewModelType, MainMapViewModelInput, MainMapViewModelOutput {
    
    var inputs: MainMapViewModelInput { return self }
    var outputs: MainMapViewModelOutput { return self }
    
    private var initialZoom = BehaviorRelay<Bool>(value: false)
    private var zooming = BehaviorRelay<Bool?>(value: nil)
    private var blockingAutoZoom = BehaviorRelay<Bool?>(value: nil)
    private var zoomBlockingTimer = BehaviorRelay<Timer?>(value: nil)
    
    init() {
        
    }
    
    func setIsInitialZoom(_ bool: Bool) {
        initialZoom.accept(bool)
    }
    
    func isInitialZoom() -> Bool {
        return initialZoom.value
    }
    
    func setIsBlockingAutoZoom(_ bool: Bool) {
        return blockingAutoZoom.accept(bool)
    }
    
    func isBlockingAutoZoom() -> Bool {
        return blockingAutoZoom.value ?? Bool()
    }
    
    func setIsZoom(_ bool: Bool) {
        zooming.accept(bool)
    }
    
    func isZoom() -> Bool {
        return zooming.value ?? Bool()
    }
    
    func setZoomBlockingTimer(_ timer: Timer?) {
        zoomBlockingTimer.accept(timer)
    }
    
    func getZoomBlockingTimer() -> Timer {
        return zoomBlockingTimer.value ?? Timer()
    }
    
    func zoomTo(location: CLLocation, left: () -> Void, right: () -> Void) {
        if isInitialZoom() == false {
            left()
        }
        if isBlockingAutoZoom() == false {
            right()
        }
    }
}
