import Foundation

struct NoteDataStoreFactory {
    
    static func createNoteRemoteDataStore() -> NoteRemoteDataStoreProtocol {
        return NoteRemoteDataStore()
    }
}
