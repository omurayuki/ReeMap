import FirebaseFirestore
import Foundation

struct Constants {
    
    struct DictKey {
        
        static let clusteringIdentifier = "clusteringIdentifier"
        static let location = "location"
    }
    
    struct Resource {
        
        static let resource = (image: "checked_note", type: "png")
    }
    
    struct Identifier {
        
        static let notification = "immediately"
    }
    
    struct RedirectURL {
        
        static let privacy = "https://github.com/omurayuki/ReeMap_Document/blob/master/privacy_policy.md"
        static let termOfSearvice = "https://github.com/omurayuki/ReeMap_Document/blob/master/terms_service.md"
        static let contactUs = "https://docs.google.com/forms/d/e/1FAIpQLSeMP09_emQt08kKojaD8xoBJpWrAnbbPU3ReSem-JTiWCCGgw/viewform"
    }
}

enum DocumentRef {
    case setNote
    case deleteNote(id: String)
    case updateNote(id: String)
    
    var destination: DocumentReference {
        switch self {
        case .setNote:
            return Firestore.firestore()
                .collection("Users")
                .document(AppUserDefaultsUtils.getUIDToken() ?? "")
                .collection("Notes")
                .document()
        case .deleteNote(let id):
            return Firestore.firestore()
                .collection("Users")
                .document(AppUserDefaultsUtils.getUIDToken() ?? "")
                .collection("Notes")
                .document(id)
        case .updateNote(let id):
            return Firestore.firestore()
                .collection("Users")
                .document(AppUserDefaultsUtils.getUIDToken() ?? "")
                .collection("Notes")
                .document(id)
        }
    }
}

enum CollectionRef {
}

enum QueryRef {
    case user
    
    var destination: Query {
        switch self {
        case .user:
            return Firestore.firestore()
                .collection("Users")
                .document(AppUserDefaultsUtils.getUIDToken() ?? "")
                .collection("Notes")
                .order(by: "updated_at", descending: true)
        }
    }
}
