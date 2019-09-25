import Foundation
import RxSwift

extension AppDelegate {
    static let container = Container()
        .register(Bundle.self, instance: Bundle.main)

        // MARK: UI
        .register(MainMapUIProtocol.self) { _ in MainMapUI() }
        .register(NoteListUIProtocol.self) { _ in NoteListUI() }
    
        // MARK: Routing
        .register(MainMapRoutingProtocol.self) { _ in MainMapRouting() }
        .register(NoteListRoutingProtocol.self) { _ in NoteListRouting() }
    
        // MARK: ViewModel
        .register(MainMapViewModel.self) { _ in MainMapViewModel(useCase: MapUseCase(repository: MapRepository())) }
        .register(NoteListViewModel.self) { _ in NoteListViewModel() }
    
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
    
        .register(NoteListViewController.self) {
            AnyVCBuilder<NoteListViewController>()
                .with(ui: $0.resolve(NoteListUIProtocol.self))
                .with(routing: $0.resolve(NoteListRoutingProtocol.self))
                .with(viewModel: $0.resolve(NoteListViewModel.self))
                .with(disposeBag: $0.resolve(DisposeBag.self))
                .build()
        }
}
