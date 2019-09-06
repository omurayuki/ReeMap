import CoreLocation
import Foundation
import RxCocoa
import RxSwift
import UIKit

extension MainMapViewController: VCInjectable {
    
    typealias UI = MainMapUIProtocol
    typealias Routing = MainMapRoutingProtocol
    typealias ViewModel = MainMapViewModelType
    
    func setupDI() {
        ui.rootView = self.view
        ui.locationManager.delegate = self
        routing.viewController = self
    }
}

final class MainMapViewController: UIViewController {
    
    var ui: MainMapUIProtocol!
    var routing: MainMapRoutingProtocol!
    var viewModel: MainMapViewModelType!
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

extension MainMapViewController {
    
}

// TODO: Delegate Class 作成
extension MainMapViewController: CLLocationManagerDelegate {
    
}
