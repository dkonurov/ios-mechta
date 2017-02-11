import Foundation
import SwiftyJSON

extension Date {
    //Произвольный формат
    static func from(_ stringValue: String?, format: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        if let value = stringValue {
            return formatter.date(from: value)
        } else {
            return nil
        }
    }
    
    private func toString(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    //Распространенные форматы
    func dmyhmsValue() -> String {
        return toString(format: "dd.MM.yyyy HH:mm:ss")
    }
    
    func dmyhmValue() -> String {
        return toString(format: "dd.MM.yyyy HH:mm")
    }
    
    func dmyValue() -> String {
        return toString(format: "dd.MM.yyyy")
    }
}

extension NSDate {
    
    //Распространенные форматы
    func dmyhmsValue() -> String {
        return (self as Date).dmyhmsValue()
    }
    
    func dmyhmValue() -> String {
        return (self as Date).dmyhmValue()
    }
    
    func dmyValue() -> String {
        return (self as Date).dmyValue()
    }
}

extension JSON {
    func fromDate(format: String) -> Date? {
        return Date.from(self.string, format: format)
    }
}
