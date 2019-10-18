import Foundation
import UIKit
import UserNotifications

extension MainMapViewController {
    
    func createLocalNotification(place: Place) {
        let content = UNMutableNotificationContent()
        content.createLocalNotification(title: R.string.localizable.remind(),
                                        content: place.content,
                                        sound: UNNotificationSound.default,
                                        resource: (image: Constants.Resource.resource.image,
                                                   type: Constants.Resource.resource.type),
                                        requestIdentifier: Constants.Identifier.notification,
                                        notificationHandler: { [unowned self] in
            self.viewModel?.updateNote([Constants.DictKey.notification: false], noteId: place.documentId)
                .subscribe(onError: { [unowned self] _ in
                    self.showError(message: R.string.localizable.could_not_update_note())
                }).disposed(by: self.disposeBag)
        })
    }
}
