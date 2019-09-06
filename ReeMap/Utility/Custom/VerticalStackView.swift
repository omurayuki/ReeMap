import UIKit

// swiftlint:disable all
class VerticalStackView: UIStackView {
    init(arrangeSubViews: [UIView], spacing: CGFloat = 0) {
        super.init(frame: .zero)
        arrangeSubViews.forEach { addArrangedSubview($0) }
        self.spacing = spacing
        self.axis = .vertical
    }
    
    required init(coder: NSCoder) {
        fatalError()
    }
}
