import Foundation
import RxSwift

extension AppDelegate {
    static let container = Container()
        .register(Bundle.self, instance: Bundle.main)

        // MARK: UI
        .register(MainMapUIProtocol.self) { _ in MainMapUI() }
        .register(NoteListUIProtocol.self) { _ in NoteListUI() }
        .register(SideMenuUIProtocol.self) { _ in SideMenuUI() }
        .register(SelectDestinationUIProtocol.self) { _ in SelectDestinationUI() }
        .register(CreateMemoUIProtocol.self) { _ in CreateMemoUI() }
        .register(SearchStreetAddressUIProtocol.self) { _ in SearchStreetAddressUI() }
        .register(EditNoteUIProtocol.self) { _ in EditNoteUI() }
    
        // MARK: Routing
        .register(MainMapRoutingProtocol.self) { _ in MainMapRouting() }
        .register(NoteListRoutingProtocol.self) { _ in NoteListRouting() }
        .register(SelectDestinationRoutingProtocol.self) { _ in SelectDestinationRouting() }
        .register(CreateMemoRoutingProtocol.self) { _ in CreateMemoRouting() }
        .register(SearchStreetAddressRoutingProtocol.self) { _ in SearchStreetAddressRouting() }
        .register(EditNoteRoutingProtocol.self) { _ in EditNoteRouting() }
    
        // MARK: ViewModel
        .register(MainMapViewModel.self) { _ in MainMapViewModel(useCase: MapUseCase(repository: MapRepository())) }
        .register(NoteListViewModel.self) { _ in NoteListViewModel(useCase: NoteListUseCase(repository: NoteListRepository())) }
        .register(SelectDestinationViewModel.self) { _ in SelectDestinationViewModel(useCase: SelectDestinationUseCase(repository: SelectDestinationRepository())) }
        .register(CreateMemoViewModel.self) { _ in CreateMemoViewModel(useCase: CreateMemoUseCase(repository: CreateMemoRepository())) }
        .register(SearchStreetAddressViewModel.self) { _ in SearchStreetAddressViewModel(useCase: SearchStreetAddressUseCase(repository: SearchStreetAddressRepository())) }
        .register(EditNoteViewModel.self) { _ in EditNoteViewModel(useCase: CreateMemoUseCase(repository: CreateMemoRepository())) }
    
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
        .register(SideMenuViewController.self) {
            AnyVCBuilder<SideMenuViewController>()
                .with(ui: $0.resolve(SideMenuUIProtocol.self))
                .with(disposeBag: $0.resolve(DisposeBag.self))
                .build()
        }
        .register(SelectDestinationViewController.self) {
            AnyVCBuilder<SelectDestinationViewController>()
                .with(ui: $0.resolve(SelectDestinationUIProtocol.self))
                .with(routing: $0.resolve(SelectDestinationRoutingProtocol.self))
                .with(viewModel: $0.resolve(SelectDestinationViewModel.self))
                .with(disposeBag: $0.resolve(DisposeBag.self))
                .build()
        }
        .register(CreateMemoViewController.self) {
            AnyVCBuilder<CreateMemoViewController>()
                .with(ui: $0.resolve(CreateMemoUIProtocol.self))
                .with(routing: $0.resolve(CreateMemoRoutingProtocol.self))
                .with(viewModel: $0.resolve(CreateMemoViewModel.self))
                .with(disposeBag: $0.resolve(DisposeBag.self))
                .build()
        }
        .register(SearchStreetAddressViewController.self) {
            AnyVCBuilder<SearchStreetAddressViewController>()
                .with(ui: $0.resolve(SearchStreetAddressUIProtocol.self))
                .with(routing: $0.resolve(SearchStreetAddressRoutingProtocol.self))
                .with(viewModel: $0.resolve(SearchStreetAddressViewModel.self))
                .with(disposeBag: $0.resolve(DisposeBag.self))
                .build()
        }
        .register(EditNoteViewController.self) {
            AnyVCBuilder<EditNoteViewController>()
                .with(ui: $0.resolve(EditNoteUIProtocol.self))
                .with(routing: $0.resolve(EditNoteRoutingProtocol.self))
                .with(viewModel: $0.resolve(EditNoteViewModel.self))
                .with(disposeBag: $0.resolve(DisposeBag.self))
                .build()
        }
}
