import MapKit
import UIKit

final class NoteListTableViewCell: UITableViewCell {
    
    var noteListImage: UIImageView = {
        let image = UIImageView(image: #imageLiteral(resourceName: "pending_note"))
        image.clipsToBounds = true
        return image
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
            noteContent.text = didPlaceUpdated?.content
            let location = CLLocation(latitude: didPlaceUpdated?.latitude ?? 0.0, longitude: didPlaceUpdated?.longitude ?? 0.0)
            CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
                guard let placemark = placemarks?.first, error == nil else { return }
                guard
                    let administrativeArea = placemark.administrativeArea,
                    let locality = placemark.locality,
                    let thoroughfare = placemark.thoroughfare,
                    let subThoroughfare = placemark.subThoroughfare
                else { return }
                self.streetAddress.text = "\(administrativeArea)\(locality)\(thoroughfare)\(subThoroughfare)"
            }
            notification ? (noteListImage.image = #imageLiteral(resourceName: "pending_note")) : (noteListImage.image = #imageLiteral(resourceName: "checked_note"))
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
