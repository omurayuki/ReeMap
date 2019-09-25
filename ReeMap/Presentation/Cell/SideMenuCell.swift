import UIKit

final class SideMenuCell: UITableViewCell {
    
    var title: UILabel = {
        let label = UILabel()
        label.apply(.h4)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}

extension SideMenuCell {
    
    private func setup() {
        backgroundColor = .white
        addSubview(title)
        
        title.anchor()
            .left(to: leftAnchor, constant: 20)
            .top(to: topAnchor, constant: 30)
            .bottom(to: bottomAnchor, constant: -30)
            .activate()
    }
}
