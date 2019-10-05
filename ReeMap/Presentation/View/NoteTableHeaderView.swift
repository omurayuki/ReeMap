import UIKit

class NoteTableHeaderView: UIView {
    
    var title: UILabel = {
        let label = UILabel()
        label.apply(.title_Bold, title: "Note:")
        return label
    }()
    
    var noteContent: UILabel = {
        let label = UILabel()
        label.apply(.h5_Bold)
        label.numberOfLines = 0
        return label
    }()
    
    var editBtn: UIButton = {
        let button = UIButton()
        button.setTitle("Edit", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 13)
        return button
    }()
    
    var streetAddress: UILabel = {
        let label = UILabel()
        label.apply(.body_Bold, title: "Address:")
        label.numberOfLines = 0
        return label
    }()
    
    var streetAddressContent: UILabel = {
        let label = UILabel()
        label.apply(.title_Bold)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}

extension NoteTableHeaderView {
    
    private func setup() {
        backgroundColor = .white
        [title, noteContent, editBtn, streetAddress, streetAddressContent].forEach { addSubview($0) }
        
        title.anchor()
            .top(to: topAnchor, constant: 20)
            .left(to: leftAnchor, constant: 20)
            .activate()
        
        noteContent.anchor()
            .top(to: title.bottomAnchor, constant: 5)
            .left(to: leftAnchor, constant: 20)
            .right(to: rightAnchor, constant: -20)
            .activate()
        
        editBtn.anchor()
            .top(to: topAnchor, constant: 14)
            .right(to: rightAnchor, constant: -20)
            .activate()
        
        streetAddress.anchor()
            .top(to: noteContent.bottomAnchor, constant: 20)
            .left(to: leftAnchor, constant: 20)
            .activate()
        
        streetAddressContent.anchor()
            .top(to: streetAddress.bottomAnchor, constant: 5)
            .left(to: leftAnchor, constant: 20)
            .right(to: rightAnchor, constant: -20)
            .activate()
    }
}
