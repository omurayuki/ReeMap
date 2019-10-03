import Foundation
import RxSwift

protocol AuthLocalDataStoreProtocol {
    
    func getUIDToken() -> String
    func setUIDToken(_ token: String)
}

struct AuthLocalDataStore: AuthLocalDataStoreProtocol {
    
    func getUIDToken() -> String {
        return AppUserDefaultsUtils.getUIDToken() ?? ""
    }
    
    func setUIDToken(_ token: String) {
        AppUserDefaultsUtils.setUIDToken(uid: token)
    }
}
