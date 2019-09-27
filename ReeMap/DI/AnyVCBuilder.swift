import RxSwift
import UIKit

final class AnyVCBuilder<T>: VCBuildable where T: UIViewController, T: VCInjectable {
    
    typealias BuildType = T
    
    private var data: Any?
    
    private var ui: T.UI!
    private var routing: T.Routing?
    private var viewModel: T.ViewModel?
    private var disposeBag: DisposeBag!
    
    func with(ui: T.UI) -> Self {
        self.ui = ui
        return self
    }
    
    func with(routing: T.Routing? = nil) -> Self {
        self.routing = routing
        return self
    }
    
    func with(viewModel: T.ViewModel? = nil) -> Self {
        self.viewModel = viewModel
        return self
    }
    
    func with(disposeBag: DisposeBag) -> Self {
        self.disposeBag = disposeBag
        return self
    }
    
    func build() -> T {
        var vc = T()
        vc.inject(
            ui: self.ui,
            routing: self.routing,
            viewModel: self.viewModel,
            disposeBag: self.disposeBag)
        return vc
    }
}
