import UIKit

final class NoteItemsBottomView: UIView {
    
    private(set) var deleteItem: UIButton = {
        let button = UIButton()
        button.imageView?.clipsToBounds = true
        button.imageView?.contentMode = .scaleAspectFit
        button.setImage(R.image.deleteButton(), for: .normal)
        return button
    }()
    
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
    
    private(set) lazy var itemsStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            deleteItem,
            cameraItem,
            saveItem,
            writeItem,
            returnItem
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

extension NoteItemsBottomView {
    
    private func setup() {
        addSubview(itemsStack)
        
        itemsStack.anchor()
            .top(to: topAnchor)
            .left(to: leftAnchor, constant: 10)
            .right(to: rightAnchor, constant: -10)
            .bottom(to: bottomAnchor)
            .activate()
        
        [deleteItem, cameraItem, writeItem, saveItem, returnItem].forEach {
            $0.anchor()
                .width(constant: frame.height * 0.5)
                .height(constant: frame.height * 0.5)
                .activate()
        }
    }
}
