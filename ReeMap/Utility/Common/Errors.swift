import Foundation

enum FirebaseError: Error {
    
    case networkError
    case resultError(Error)
    case unknown
}
