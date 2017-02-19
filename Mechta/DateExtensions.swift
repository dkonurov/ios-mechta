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
    
    static func fromHm(_ stringValue: String?) -> Date? {
        let date = from(startTimeStr, format: "HH:mm")
        return date
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
    
    func hmValue() -> String {
        return toString(format: "HH:mm")
    }
    
    func isWorkingDay() -> Bool {
        return !isWeekend()
    }
    
    func isWeekend() -> Bool {
        let day = self.weekday
        return day == 1 || day == 7
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
