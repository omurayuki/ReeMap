import Foundation
import RxCocoa
import RxSwift

protocol MapViewModelInput {
    
}

protocol MapViewModelOutput {
    
}

protocol MapViewModelType: ViewModel {
    
    var inputs: MapViewModelInput { get }
    var outputs: MapViewModelOutput { get }
}

struct MapViewModel: MapViewModelType, MapViewModelInput, MapViewModelOutput {
    
    var inputs: MapViewModelInput { return self }
    var outputs: MapViewModelOutput { return self }
    
}
