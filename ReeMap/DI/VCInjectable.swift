import RxSwift
import UIKit

protocol VCInjectable {
    
    associatedtype UI
    associatedtype Routing
    associatedtype ViewModel
    
    var ui: UI! { get set }
    var routing: Routing! { get set }
    var viewModel: ViewModel! { get set }
    var disposeBag: DisposeBag! { get set }
    
    func setupConfig()
    
    mutating func inject(
        ui: UI,
        routing: Routing,
        viewModel: ViewModel,
        disposeBag: DisposeBag)
}

extension VCInjectable where Self: UIViewController {
    
    mutating func inject(
        ui: UI,
        routing: Routing,
        viewModel: ViewModel,
        disposeBag: DisposeBag) {
        self.ui = ui
        self.routing = routing
        self.viewModel = viewModel
        self.disposeBag = disposeBag
    }
}
