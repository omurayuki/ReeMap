import Foundation
import FirebaseAuth

enum FirestoreResponse<T> {
    
    case success(T)
    case failure(Error)
    case unknown
}
