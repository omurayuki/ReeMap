import Foundation

typealias FirestoreObjectResponseHandler<T> = (_ response: FirestoreResponse<T>) -> Void
typealias VersionConstitution = (title: String, content: String)
typealias NoteDetailConstitution = (documentId: String, content: String, streetAddress: String)
