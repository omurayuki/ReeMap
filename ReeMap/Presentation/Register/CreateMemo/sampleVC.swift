import Foundation
import UIKit

class SampleVC: UIViewController {
    
    var label: UIImageView = {
        let label = UIImageView()
        return label
    }()
    
    var text: UIImage!
    
    init(text: UIImage) {
        self.text = text
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(label)
        
        label.anchor()
            .edgesToSuperview()
            .activate()
        
        label.image = text
    }
}
