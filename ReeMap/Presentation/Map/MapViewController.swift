import Foundation
import RxCocoa
import RxSwift
import UIKit

extension MapViewController: VCInjectable {
    
    typealias UI = MapUIProtocol
    typealias Routing = MapRoutingProtocol
    typealias ViewModel = MapViewModelType
    
    func setupDI() {
        ui.rootView = self.view
        routing.viewController = self
    }
}

final class MapViewController: UIViewController {
    
    var ui: MapUIProtocol!
    var routing: MapRoutingProtocol!
    var viewModel: MapViewModelType!
    var disposeBag: DisposeBag!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDI()
        setupUI()
        setupViewModel()
    }
    
    private func setupUI() {
        
    }
    
    private func setupViewModel() {
        
    }
}
