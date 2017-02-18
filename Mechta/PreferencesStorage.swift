import Foundation

class PreferencesStorage {
    private static let keyStartBusStopId = "StartBusStopId"
    var startBusStopId: Int64?
    
    private static let keyEndBusStopId = "EndBusStopId"
    var endBusStopId: Int64?
    
    private init() {}
    
    static func load() -> PreferencesStorage {
        let defaults = UserDefaults.standard
        let storage = PreferencesStorage()
        storage.startBusStopId = defaults.object(forKey: PreferencesStorage.keyStartBusStopId) as? Int64
        storage.endBusStopId = defaults.object(forKey: PreferencesStorage.keyEndBusStopId) as? Int64
        return storage
    }
    
    func save() {
        let defaults = UserDefaults.standard
        defaults.set(startBusStopId, forKey: PreferencesStorage.keyStartBusStopId)
        defaults.set(endBusStopId, forKey: PreferencesStorage.keyEndBusStopId)
        defaults.synchronize()
    }
    
    func clear() {
        startBusStopId = nil
        endBusStopId = nil
        
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: PreferencesStorage.keyStartBusStopId)
        defaults.removeObject(forKey: PreferencesStorage.keyEndBusStopId)
        defaults.synchronize()
    }
}
