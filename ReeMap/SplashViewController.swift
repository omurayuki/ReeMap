import Foundation
import Lottie
import UIKit

protocol SplashDelegate: NSObject {
    
    func didFinishSplashAnimation()
}

final class SplashViewController: UIViewController {
    
    weak var delegate: SplashDelegate!
    
    lazy var loadingView: AnimationView = {
        let view = AnimationView(name: Constants.Json.locationMapPin)
        view.center = self.view.center
        view.loopMode = .playOnce
        view.contentMode = .scaleAspectFit
        view.animationSpeed = 1.2
        return view
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setup()
        loadingView.play { [unowned self] bool in
            if bool {
                self.delegate.didFinishSplashAnimation()
            }
        }
    }
}

extension SplashViewController {
    
    private func setup() {
        view.addSubview(loadingView)
        
        loadingView.anchor()
            .centerToSuperview()
            .width(constant: view.frame.width * 0.7)
            .height(constant: view.frame.width * 0.7)
            .activate()
    }
}
