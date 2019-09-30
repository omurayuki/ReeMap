import UIKit

final class NoteListTableViewCell: UITableViewCell {
    
    var noteListImage: UIImageView = {
        let image = UIImageView(image: #imageLiteral(resourceName: "location"))
        image.clipsToBounds = true
        image.layer.cornerRadius = 25
        return image
    }()
    
    var noteContent: UILabel = {
        let label = UILabel()
        label.apply(.h5_Bold)
        return label
    }()
    
    var streetAddress: UILabel = {
        let label = UILabel()
        label.apply(.body, title: "京都市右京区西京極中沢町1-13")
        return label
    }()
    
    var didPlaceUpdated: Place? {
        didSet {
            noteContent.text = didPlaceUpdated?.content
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
        [noteListImage, noteContent, streetAddress].forEach { addSubview($0) }
        
        noteListImage.anchor()
            .top(to: topAnchor, constant: 10)
            .left(to: leftAnchor, constant: 20)
            .bottom(to: bottomAnchor, constant: -10)
            .width(constant: 50)
            .height(constant: 50)
            .activate()
        
        noteContent.anchor()
            .top(to: topAnchor, constant: 15)
            .left(to: noteListImage.rightAnchor, constant: 15)
            .width(constant: frame.width * 0.9 - 50)
            .activate()
        
        streetAddress.anchor()
            .top(to: noteContent.bottomAnchor, constant: 5)
            .left(to: noteListImage.rightAnchor, constant: 15)
            .width(constant: frame.width * 0.9 - 50)
            .activate()
    }
}
