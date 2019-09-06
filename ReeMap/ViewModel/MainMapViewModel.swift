import Foundation
import RxCocoa
import RxSwift

protocol MainMapViewModelInput {
    
}

protocol MainMapViewModelOutput {
    
}

protocol MainMapViewModelType: ViewModel {
    
    var inputs: MainMapViewModelInput { get }
    var outputs: MainMapViewModelOutput { get }
}

struct MainMapViewModel: MainMapViewModelType, MainMapViewModelInput, MainMapViewModelOutput {
    
    var inputs: MainMapViewModelInput { return self }
    var outputs: MainMapViewModelOutput { return self }
    
}
