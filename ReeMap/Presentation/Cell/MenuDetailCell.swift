import UIKit

final class MenuDetailCell: UITableViewCell {
    
    var title: UILabel = {
        let label = UILabel()
        label.apply(.h5)
        return label
    }()
    
    var content: UILabel = {
        let label = UILabel()
        label.apply(.h5_appSub)
        return label
    }()
    
    var didAccept: VersionConstitution! {
        didSet {
            title.text = didAccept.title
            content.text = didAccept.content
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

extension MenuDetailCell {
    
    private func setup() {
        [title, content].forEach { addSubview($0) }
        
        title.anchor()
            .centerYToSuperview()
            .left(to: leftAnchor, constant: 10)
            .activate()
        
        content.anchor()
            .centerYToSuperview()
            .right(to: rightAnchor, constant: -10)
            .activate()
    }
}
