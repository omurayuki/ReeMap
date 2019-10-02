import Foundation

typealias FirestoreObjectResponseHandler<T> = (_ response: FirestoreResponse<T>) -> Void
