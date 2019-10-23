import Foundation
import Reachability

final class NetworkService: NSObject {
    
    var reachability: Reachability!
    
    static let sharedInstance: NetworkService = {
        NetworkService()
    }()
    
    override init() {
        super.init()
        reachability = Reachability()
        
        do {
            try reachability?.startNotifier()
        } catch {
            fatalError("Unable to stast notifier")
        }
    }
    
    static func stopNotifier() {
        do {
            try (NetworkService.sharedInstance.reachability)?.startNotifier()
        } catch {
            print("Error stopping notifier")
        }
    }

    static func isReachable() -> Bool {
        if NetworkService.sharedInstance.reachability.connection != .none {
            return true
        }
        return false
    }
    
    static func isUnreachable() -> Bool {
        if NetworkService.sharedInstance.reachability.connection == .none {
            return true
        }
        return false
    }
    
    static func isReachableViaWWAN() -> Bool {
        if NetworkService.sharedInstance.reachability.connection == .cellular {
            return true
        }
        return false
    }

    static func isReachableViaWiFi() -> Bool {
        if NetworkService.sharedInstance.reachability.connection == .wifi {
            return true
        }
        return false
    }
}
