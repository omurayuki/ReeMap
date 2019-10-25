import UIKit

final class NoteItemsView: UIView {
    
    private(set) var cameraItem: UIButton = {
        let button = UIButton()
        button.imageView?.clipsToBounds = true
        button.imageView?.contentMode = .scaleAspectFit
        button.setImage(R.image.camera(), for: .normal)
        return button
    }()
    
    private(set) var writeItem: UIButton = {
        let button = UIButton()
        button.imageView?.clipsToBounds = true
        button.imageView?.contentMode = .scaleAspectFit
        button.setImage(R.image.writing(), for: .normal)
        return button
    }()
    
    private(set) var saveItem: UIButton = {
        let button = UIButton()
        button.imageView?.clipsToBounds = true
        button.imageView?.contentMode = .scaleAspectFit
        button.setImage(R.image.download(), for: .normal)
        return button
    }()
    
    private(set) var returnItem: UIButton = {
        let button = UIButton()
        button.imageView?.clipsToBounds = true
        button.imageView?.contentMode = .scaleAspectFit
        button.setImage(R.image.previous(), for: .normal)
        return button
    }()
    
    private(set) var cancelItem: UIButton = {
        let button = UIButton()
        button.setTitle("＋  ", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 30)
        button.setTitleColor(.gray, for: .normal)
        button.rotate(per: -45)
        return button
    }()
    
    private var cushionView: UIView = {
        let view = UIView()
        return view
    }()
    
    private(set) lazy var verticalItemsStack: VerticalStackView = {
        let stack = VerticalStackView(arrangeSubViews: [
            cancelItem,
            cushionView
        ])
        stack.distribution = .equalSpacing
        return stack
    }()
    
    private(set) lazy var itemsStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            cameraItem,
            saveItem,
            writeItem,
            returnItem,
            verticalItemsStack
        ])
        stack.backgroundColor = .clear
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .equalSpacing
        return stack
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
}

extension NoteItemsView {
    
    private func setup() {
        addSubview(itemsStack)
        
        itemsStack.anchor()
            .top(to: topAnchor)
            .left(to: leftAnchor, constant: 10)
            .right(to: rightAnchor, constant: -10)
            .bottom(to: bottomAnchor)
            .activate()
        
        [cameraItem, writeItem, saveItem, returnItem, cancelItem].forEach {
            $0.anchor()
                .width(constant: frame.height * 0.6)
                .height(constant: frame.height * 0.6)
                .activate()
        }
        
        cushionView.anchor()
            .height(constant: 7)
            .activate()
    }
}
