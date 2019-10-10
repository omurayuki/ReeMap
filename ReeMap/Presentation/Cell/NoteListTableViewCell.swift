import MapKit
import UIKit

final class NoteListTableViewCell: UITableViewCell {
    
    var noteListImage: UIImageView = {
        let image = UIImageView(image: #imageLiteral(resourceName: "pending_note"))
        image.clipsToBounds = true
        return image
    }()
    
    var notePostedTime: UILabel = {
        let label = UILabel()
        label.apply(.body)
        return label
    }()
    
    var noteContent: UILabel = {
        let label = UILabel()
        label.apply(.h5_Bold)
        return label
    }()
    
    var streetAddress: UILabel = {
        let label = UILabel()
        label.apply(.body)
        return label
    }()
    
    var didPlaceUpdated: Place? {
        didSet {
            guard let notification = didPlaceUpdated?.notification else { return }
            notePostedTime.text = didPlaceUpdated?.updatedAt.offsetFrom()
            noteContent.text = didPlaceUpdated?.content
            streetAddress.text = didPlaceUpdated?.streetAddress
            notification ? (noteListImage.image = #imageLiteral(resourceName: "pending_note")) : (noteListImage.image = #imageLiteral(resourceName: "checked_note"))
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
}

extension NoteListTableViewCell {
    
    private func setup() {
        backgroundColor = .clear
        [noteListImage, notePostedTime, noteContent, streetAddress].forEach { addSubview($0) }
        
        noteListImage.anchor()
            .centerYToSuperview()
            .left(to: leftAnchor, constant: 20)
            .width(constant: 50)
            .height(constant: 50)
            .activate()
        
        notePostedTime.anchor()
            .top(to: topAnchor, constant: 10)
            .right(to: rightAnchor, constant: -20)
            .activate()
        
        noteContent.anchor()
            .top(to: topAnchor, constant: 10)
            .left(to: noteListImage.rightAnchor, constant: 15)
            .width(constant: frame.width - (150 + 35))
            .activate()
        
        streetAddress.anchor()
            .top(to: noteContent.bottomAnchor, constant: 10)
            .left(to: noteListImage.rightAnchor, constant: 15)
            .bottom(to: bottomAnchor, constant: -10)
            .width(constant: frame.width * 0.9 - 50)
            .activate()
    }
}
