import UIKit

class NoteDetailCell: UITableViewCell {
    
    var streetAddress: UILabel = {
        let label = UILabel()
        label.apply(.body_Bold, title: "住所:")
        label.numberOfLines = 0
        return label
    }()
    
    var streetAddressContent: UILabel = {
        let label = UILabel()
        label.apply(.title_Bold)
        return label
    }()
    
    var editBtn: UIButton = {
        let button = UIButton()
        button.setTitle("編集", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 13)
        return button
    }()
    
    var title: UILabel = {
        let label = UILabel()
        label.apply(.title_Bold, title: "内容:")
        return label
    }()
    
    var noteContent: UILabel = {
        let label = UILabel()
        label.apply(.h5_Bold)
        label.numberOfLines = 0
        return label
    }()
    
    var didRecieveDetail: NoteDetailConstitution! {
        didSet {
            streetAddressContent.text = didRecieveDetail.streetAddress
            noteContent.text = didRecieveDetail.content
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}

extension NoteDetailCell {
    
    private func setup() {
        backgroundColor = .clear
        [streetAddress, streetAddressContent, editBtn, title, noteContent].forEach { addSubview($0) }
        
        streetAddress.anchor()
            .top(to: topAnchor, constant: 55)
            .left(to: leftAnchor, constant: 20)
            .activate()
        
        streetAddressContent.anchor()
            .top(to: streetAddress.bottomAnchor, constant: 5)
            .left(to: leftAnchor, constant: 20)
            .right(to: rightAnchor, constant: -20)
            .activate()
        
        editBtn.anchor()
            .top(to: topAnchor, constant: 49)
            .right(to: rightAnchor, constant: -20)
            .activate()
        
        title.anchor()
            .top(to: streetAddressContent.bottomAnchor, constant: 20)
            .left(to: leftAnchor, constant: 20)
            .activate()
        
        noteContent.anchor()
            .top(to: title.bottomAnchor, constant: 5)
            .left(to: leftAnchor, constant: 20)
            .right(to: rightAnchor, constant: -20)
            .bottom(to: bottomAnchor, constant: -20)
            .activate()
    }
}
