// swiftlint:disable all
import Foundation

class AppUserDefaultsUtils {
    
    // Email
    class func getAccountEmail() -> String? {
        return getStringValue(keyName: "AccountEmail") ?? nil
    }
    
    class func setAccountEmail(email: String) {
        putStringValue(email, keyName: "AccountEmail")
    }
    
    // UIDToken
    class func getUIDToken() -> String? {
        return getStringValue(keyName: "AnonymousUserToken") ?? nil
    }
    
    class func setUIDToken(uid: String) {
        putStringValue(uid, keyName: "AnonymousUserToken")
    }
    
    // Remind Meter
    class func getRemindMeter() -> Double {
        return getDoubleValue(keyName: "remindRangeMeter")
    }
    
    class func setRangeMeter(_ meter: Double) {
        putDoubleValue(meter, keyName: "remindRangeMeter")
    }
}

extension AppUserDefaultsUtils {
    
    private class func getStringValue(keyName: String) -> String? {
        let userDefaults = UserDefaults.standard
        return userDefaults.string(forKey: keyName)
    }
    
    private class func putStringValue(_ value: String, keyName: String) {
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(value, forKey: keyName)
    }
    
    private class func getIntValue(keyName: String) -> Int {
        let userDefaults = UserDefaults.standard
        return userDefaults.integer(forKey: keyName)
    }
    
    private class func putIntValue(_ value: Int, keyName: String) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(value, forKey: keyName)
    }
    
    private class func getDoubleValue(keyName: String) -> Double {
        let userDefaults = UserDefaults.standard
        return userDefaults.double(forKey: keyName)
    }
    
    private class func putDoubleValue(_ value: Double, keyName: String) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(value, forKey: keyName)
    }
    
    private class func getBoolValue(keyName: String) -> Bool {
        let userDefaults = UserDefaults.standard
        return userDefaults.bool(forKey: keyName)
    }
    
    private class func putBoolValue(_ value: Bool, keyName: String) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(value, forKey: keyName)
    }
    
    private class func getStructValue<T: Codable>(keyName: String) -> [T] {
        let userDefaults = UserDefaults.standard
        guard let data = userDefaults.array(forKey: keyName) as? [Data] else { return [] }
        return data.map {
            do {
                return try JSONDecoder().decode(T.self, from: $0)
            } catch let error {
                fatalError("could not decode value - Error content: \(error.localizedDescription)")
            }
        }
    }
    
    private class func putStructValue<T: Codable>(_ value: [T], keyName: String) {
        let userDefaults = UserDefaults.standard
        let data = value.map { try? JSONEncoder().encode($0) }
        userDefaults.set(data, forKey: keyName)
    }
    
    private class func getArrayValue<T>(keyName: String) -> [T] {
        let userDefaults = UserDefaults.standard
        guard let data = userDefaults.array(forKey: keyName) as? [T] else { return [] }
        return data
    }
    
    private class func setArrayValue<T>(_ value: [T], keyName: String) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(value, forKey: keyName)
    }
    
    private class func clearArrayValue(keyName: String) {
        let userDefaults = UserDefaults.standard
        userDefaults.removeObject(forKey: keyName)
    }
}
