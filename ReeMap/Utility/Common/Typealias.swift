import Foundation

typealias EntityType = [String: Any]
typealias CompletionObject<T> = (_ response: T) -> Void
typealias FirestoreObjectResponseHandler<T> = (_ response: FirestoreResponse<T>) -> Void
typealias VersionConstitution = (title: String, content: String)
typealias NoteDetailConstitution = (documentId: String, content: String, streetAddress: String, notification: Bool)
