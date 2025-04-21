import Foundation

class DateUtility {
    static let shared = DateUtility()

    init() {}

    func dateFromTimeStamp(_ timestamp: Int64) -> Date {
        return Date(timeIntervalSince1970: TimeInterval(timestamp))
    }

    func isSameDay(timestamp1: Int64, timestamp2: Int64) -> Bool {
        let date1 = dateFromTimeStamp(timestamp1)
        let date2 = dateFromTimeStamp(timestamp2)

        return Calendar.current.isDate(date1, inSameDayAs: date2)
    }
}
