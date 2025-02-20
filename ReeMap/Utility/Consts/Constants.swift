import FirebaseFirestore
import Foundation

struct Constants {
    
    struct DictKey {
        
        static let uid = "uid"
        static let clusteringIdentifier = "clusteringIdentifier"
        static let location = "location"
        static let notification = "notification"
        static let updatedAt = "updated_at"
        static let createdAt = "created_at"
        static let content = "content"
        static let geoPoint = "geo_point"
        // MARK: Firestore Migrationする
        static let streetAddress = "street_addresss"
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

let firebaseFirestore = Firestore.firestore()

enum DocumentRef {
    
    case setNote
    case deleteNote(id: String)
    case updateNote(id: String)
    
    var destination: DocumentReference {
        switch self {
        case .setNote:
            return firebaseFirestore
                .collection("Users")
                .document(AppUserDefaultsUtils.getUIDToken() ?? "")
                .collection("Notes")
                .document()
        case .deleteNote(let id):
            return firebaseFirestore
                .collection("Users")
                .document(AppUserDefaultsUtils.getUIDToken() ?? "")
                .collection("Notes")
                .document(id)
        case .updateNote(let id):
            return firebaseFirestore
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
            return firebaseFirestore
                .collection("Users")
                .document(AppUserDefaultsUtils.getUIDToken() ?? "")
                .collection("Notes")
                .order(by: "updated_at", descending: true)
        }
    }
}
