import Foundation
import RxSwift

extension AppDelegate {
    static let container = Container()
        .register(Bundle.self, instance: Bundle.main)

        // MARK: UI
        .register(MainMapUIProtocol.self) { _ in MainMapUI() }
    
        // MARK: Routing
        .register(MainMapRoutingProtocol.self) { _ in MainMapRouting() }
    
        // MARK: ViewModel
        .register(MainMapViewModel.self) { _ in MainMapViewModel(useCase: MapUseCase(repository: MapRepository())) }
    
        // MARK: DisposeBag
        .register(DisposeBag.self) { _ in DisposeBag() }
    
        // MARK: ViewController
        .register(MainMapViewController.self) {
            AnyVCBuilder<MainMapViewController>()
                .with(ui: $0.resolve(MainMapUIProtocol.self))
                .with(routing: $0.resolve(MainMapRoutingProtocol.self))
                .with(viewModel: $0.resolve(MainMapViewModel.self))
                .with(disposeBag: $0.resolve(DisposeBag.self))
                .build()
        }
}
