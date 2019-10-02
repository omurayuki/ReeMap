import Foundation
import RxSwift

protocol AuthLocalDataStoreProtocol {
    
    func getUIDToken() -> Single<String>
    func setUIDToken(_ token: String)
}

struct AuthLocalDataStore: AuthLocalDataStoreProtocol {
    
    func getUIDToken() -> Single<String> {
        return Single.create(subscribe: { single -> Disposable in
            single(.success(AppUserDefaultsUtils.getUIDToken() ?? ""))
            return Disposables.create()
        })
    }
    
    func setUIDToken(_ token: String) {
        AppUserDefaultsUtils.setUIDToken(uid: token)
    }
}
