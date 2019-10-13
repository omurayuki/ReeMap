import MapKit
import RxCocoa
import RxSwift
import UIKit

protocol NoteListDelegate: NSObject {
    
    func switchNotification(_ isOn: Bool, docId: String)
}

final class NoteListTableViewCell: UITableViewCell {
    
    weak var delegate: NoteListDelegate!
    
    private var disposeBag = DisposeBag()
    
    var docId: String!
    
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
    
    var notificationSwitchBtn: UISwitch = {
        let button = UISwitch()
        return button
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
            notificationSwitchBtn.setOn(notification, animated: true)
            noteContent.text = didPlaceUpdated?.content
            streetAddress.text = didPlaceUpdated?.streetAddress
            notification ? (noteListImage.image = #imageLiteral(resourceName: "pending_note")) : (noteListImage.image = #imageLiteral(resourceName: "checked_note"))
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
        bindUI()
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        bindUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}

extension NoteListTableViewCell {
    
    private func setup() {
        backgroundColor = .clear
        [noteListImage, notePostedTime, notificationSwitchBtn, noteContent, streetAddress].forEach { addSubview($0) }
        
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
        
        notificationSwitchBtn.anchor()
            .top(to: notePostedTime.bottomAnchor, constant: 10)
            .right(to: rightAnchor, constant: -20)
            .bottom(to: bottomAnchor, constant: -10)
            .activate()
        
        noteContent.anchor()
            .top(to: topAnchor, constant: 10)
            .left(to: noteListImage.rightAnchor, constant: 15)
            .width(constant: frame.width - (150 + 35))
            .activate()
        
        streetAddress.anchor()
            .top(to: noteContent.bottomAnchor, constant: 10)
            .left(to: noteListImage.rightAnchor, constant: 15)
            .width(constant: frame.width * 0.9 - 50)
            .activate()
    }
}

extension NoteListTableViewCell {
    
    private func bindUI() {
        notificationSwitchBtn.rx
            .controlEvent(.valueChanged)
            .withLatestFrom(notificationSwitchBtn.rx.value)
            .subscribe(onNext: { [unowned self] isOn in
                self.delegate.switchNotification(isOn, docId: self.docId)
            }).disposed(by: disposeBag)
    }
}
