import UIKit

final class NoteListTableViewCell: UITableViewCell {
    
    var noteListImage: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.layer.cornerRadius = 25
        image.backgroundColor = .orange
        return image
    }()
    
    var noteTitle: UILabel = {
        let label = UILabel()
        label.apply(.h5_Bold, title: "no title")
        return label
    }()
    
    var streetAddress: UILabel = {
        let label = UILabel()
        label.apply(.body, title: "京都市右京区西京極中沢町1-13")
        return label
    }()
    
    var didPlaceUpdated: Place? {
        didSet {
            noteTitle.text = didPlaceUpdated?.title
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

extension NoteListTableViewCell {
    
    private func setup() {
        backgroundColor = .clear
        [noteListImage, noteTitle, streetAddress].forEach { addSubview($0) }
        
        noteListImage.anchor()
            .top(to: topAnchor, constant: 10)
            .left(to: leftAnchor, constant: 20)
            .bottom(to: bottomAnchor, constant: -10)
            .width(constant: 50)
            .height(constant: 50)
            .activate()
        
        noteTitle.anchor()
            .top(to: topAnchor, constant: 15)
            .left(to: noteListImage.rightAnchor, constant: 15)
            .right(to: rightAnchor, constant: -20)
            .activate()
        
        streetAddress.anchor()
            .top(to: noteTitle.bottomAnchor, constant: 5)
            .left(to: noteListImage.rightAnchor, constant: 15)
            .right(to: rightAnchor, constant: -20)
            .activate()
    }
}
