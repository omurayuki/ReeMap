import CoreLocation
import Foundation
import RxCocoa
import RxSwift

final class MainMapViewModel: ViewModel {
    
    private let useCase: MapUseCaseProtocol
    
    private var initialZoom = BehaviorRelay<Bool>(value: false)
    private var zooming = BehaviorRelay<Bool?>(value: nil)
    private var blockingAutoZoom = BehaviorRelay<Bool?>(value: nil)
    private var zoomBlockingTimer = BehaviorRelay<Timer?>(value: nil)
    
    init(useCase: MapUseCaseProtocol) {
        self.useCase = useCase
    }
}

extension MainMapViewModel {
    
    struct Input {}
    
    struct Output {}
    
    func transform(input: Input) -> Output {
        
        return Output()
    }
}

extension MainMapViewModel {
    
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
    
    func sample() -> Observable<[Place]> {
        return useCase.fetchMemos()
    }
}
