import UIKit

final class NoteItemsView: UIView {
    
    private(set) var cameraItem: UIButton = {
        let button = UIButton()
        button.backgroundColor = .green
        return button
    }()
    
    private(set) var writeItem: UIButton = {
        let button = UIButton()
        button.backgroundColor = .purple
        return button
    }()
    
    private(set) var saveItem: UIButton = {
        let button = UIButton()
        button.backgroundColor = .blue
        return button
    }()
    
    private(set) var returnItem: UIButton = {
        let button = UIButton()
        button.backgroundColor = .gray
        return button
    }()
    
    private(set) var cancelItem: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        return button
    }()
    
    private(set) lazy var itemsStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            cameraItem,
            saveItem,
            writeItem,
            returnItem,
            cancelItem
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
                .width(constant: frame.height * 0.8)
                .height(constant: frame.height * 0.8)
                .activate()
        }
    }
}
