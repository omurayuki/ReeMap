import FirebaseAuth
import Foundation
import RxSwift

struct AuthProvider {
    
    func authenticateAnonymous() -> Single<UserEntity> {
        return Single.create(subscribe: { single -> Disposable in
            Auth.auth().signInAnonymously(completion: { result, error in
                if let error = error {
                    single(.error(FirebaseError.resultError(error)))
                    return
                }
                guard let result = result else { single(.error(FirebaseError.unknown)); return }
                single(.success(UserEntity(authData: result)))
            })
            return Disposables.create()
        })
    }
}
