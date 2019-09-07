import Foundation
import RxSwift

extension AppDelegate {
    static let container = Container()
        .register(Bundle.self, instance: Bundle.main)

        // UI
        .register(MainMapUIProtocol.self) { _ in MainMapUI() }
    
        // Routing
        .register(MainMapRoutingProtocol.self) { _ in MainMapRouting() }
    
        // ViewModel
        .register(MainMapViewModelType.self) { _ in MainMapViewModel() }
    
        // DisposeBag
        .register(DisposeBag.self) { _ in DisposeBag() }
    
        // ViewController
        .register(MainMapViewController.self) {
            AnyVCBuilder<MainMapViewController>()
                .with(ui: $0.resolve(MainMapUIProtocol.self))
                .with(routing: $0.resolve(MainMapRoutingProtocol.self))
                .with(viewModel: $0.resolve(MainMapViewModelType.self))
                .with(disposeBag: $0.resolve(DisposeBag.self))
                .build()
        }
}
