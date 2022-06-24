//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation

public extension CommonExtension where Target == Date {
    var seconds: Int { target.seconds }
    var minutes: Int { target.minutes }
    var hours: Int { target.hours }
    var day: Int { target.day}
    var month: Int { target.month}
    var year: Int { target.year }
    func add(seconds: Int) -> Date { target.add(seconds: seconds) }
    func add(minutes: Int) -> Date { target.add(minutes: minutes) }
    func add(hours: Int) -> Date { target.add(hours: hours) }
    func add(days: Int) -> Date { target.add(days: days) }
    func add(month: Int) -> Date { target.add(month: month) }
    static func with(_ dateToParse: String, dateFormat: String="yyyy-MM-dd'T'HH:mm:ssXXX") -> Date? {
        Date.with(dateToParse, dateFormat: dateFormat)
    }
    func isBiggerThan(_ dateToCompare: Date) -> Bool {
        target.isBiggerThan(dateToCompare)
    }
    func timeAgoString(resources: [String]=["sec ago", "min ago", "hrs ago", "days ago", "weeks ago"]) -> String {
        target.timeAgoString(resources: resources)
    }
}

public extension Date {

    static var utcNow: Date { return Date() }

    init(string: String) {
        self = Date.with(string) ?? Date.utcNow
    }

    static func with(_ dateToParse: String, dateFormat: String="yyyy-MM-dd'T'HH:mm:ssXXX") -> Date? {
        guard dateToParse != "null" else { return nil }
        guard dateToParse != "nil" else { return nil }
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = dateFormat // http://userguide.icu-project.org/formatparse/datetime
        if let result = dateFormatter.date(from: dateToParse) { return result }
        if let date = dateToParse.dates?.first { return date }
        return nil
    }

    var timeStyleShort: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .none
        return formatter.string(from: self)
    }
    
    var timeStyleMedium: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateStyle = .none
        return formatter.string(from: self)
    }
    
    var seconds: Int { return ((Calendar.current as NSCalendar).components([.second], from: self).second)! }
    var minutes: Int { return ((Calendar.current as NSCalendar).components([.minute], from: self).minute)! }
    var hours: Int { return ((Calendar.current as NSCalendar).components([.hour], from: self).hour)! }
    var day: Int { return ((Calendar.current as NSCalendar).components([.day], from: self).day)! }
    var month: Int { return ((Calendar.current as NSCalendar).components([.month], from: self).month)! }
    var year: Int { return ((Calendar.current as NSCalendar).components([.year], from: self).year)! }

    func add(days: Int) -> Date { add(hours: days * 24) }
    func add(hours: Int) -> Date { add(minutes: hours * 60) }
    func add(minutes: Int) -> Date { add(seconds: minutes * 60) }
    func add(seconds: Int) -> Date { NSCalendar.current.date(byAdding: .second, value: seconds, to: self)! }
    func add(month: Int) -> Date { NSCalendar.current.date(byAdding: .month, value: month, to: self)! }

    func isBiggerThan(_ dateToCompare: Date) -> Bool {
        compare(dateToCompare) == ComparisonResult.orderedDescending
    }

    func timeAgoString(resources: [String]=["sec ago", "min ago", "hrs ago", "days ago", "weeks ago"]) -> String {
        let calendar = Calendar.current
        let minuteAgo = calendar.date(byAdding: .minute, value: -1, to: Date())!
        let hourAgo = calendar.date(byAdding: .hour, value: -1, to: Date())!
        let dayAgo = calendar.date(byAdding: .day, value: -1, to: Date())!
        let weekAgo = calendar.date(byAdding: .day, value: -7, to: Date())!

        if minuteAgo < self {
            let diff = Calendar.current.dateComponents([.second], from: self, to: Date()).second ?? 0
            return "\(diff) \(resources[0])"
        } else if hourAgo < self {
            let diff = Calendar.current.dateComponents([.minute], from: self, to: Date()).minute ?? 0
            return "\(diff) \(resources[1])"
        } else if dayAgo < self {
            let diff = Calendar.current.dateComponents([.hour], from: self, to: Date()).hour ?? 0
            return "\(diff) \(resources[2])"
        } else if weekAgo < self {
            let diff = Calendar.current.dateComponents([.day], from: self, to: Date()).day ?? 0
            return "\(diff) \(resources[3])"
        }
        let diff = Calendar.current.dateComponents([.weekOfYear], from: self, to: Date()).weekOfYear ?? 0
        return "\(diff) \(resources[4])"
    }
}
