import Foundation

struct DateUtils {
    static func yearTitle(from date: Date, localeIdentifier: String = "ko_kr") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("yyyy")
        dateFormatter.locale = Locale(identifier: localeIdentifier)
        return dateFormatter.string(from: date)
    }

    static func monthTitle(from date: Date, localeIdentifier: String = "ko_kr") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("M")
        dateFormatter.locale = Locale(identifier: localeIdentifier)
        return dateFormatter.string(from: date)
    }

    static func dayTitle(from date: Date, localeIdentifier: String = "ko_kr") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("d")
        dateFormatter.locale = Locale(identifier: localeIdentifier)
        return dateFormatter.string(from: date)
    }

    static func day(from date: Date, localeIdentifier: String = "ko_kr") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("E")
        dateFormatter.locale = Locale(identifier: localeIdentifier)
        return dateFormatter.string(from: date)
    }
}
