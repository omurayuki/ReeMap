import FirebaseFirestore

//// CollectionReference
extension Firestore {
    
    var user: Query {
        return collection("Users")
            .document(AppUserDefaultsUtils.getUIDToken() ?? "")
            .collection("Notes")
            .order(by: "updated_at", descending: true)
    }
}

//// DocumentReference
extension Firestore {
    
    var note: DocumentReference {
        return collection("Users")
            .document(String(describing: AppUserDefaultsUtils.getUIDToken()))
            .collection("Notes")
            .document()
    }
}
