import UIKit
import MapKit

final class StreetAddressCell: UITableViewCell {
    
    var destination: UILabel = {
        let label = UILabel()
        label.apply(.h5_Bold)
        return label
    }()
    
    var streetAddress: UILabel = {
        let label = UILabel()
        label.apply(.body)
        return label
    }()
    
    var mapItem: MKMapItem? {
        didSet {
            destination.text = mapItem?.placemark.name
            streetAddress.text = mapItem?.placemark.title
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

extension StreetAddressCell {
    
    private func setup() {
        backgroundColor = .clear
        [destination, streetAddress].forEach { addSubview($0) }
        
        destination.anchor()
            .top(to: topAnchor, constant: 15)
            .left(to: leftAnchor, constant: 20)
            .width(constant: frame.width * 0.9)
            .activate()
        
        streetAddress.anchor()
            .top(to: destination.bottomAnchor, constant: 5)
            .left(to: leftAnchor, constant: 20)
            .bottom(to: bottomAnchor, constant: -5)
            .width(constant: frame.width * 0.9)
            .activate()
    }
}
