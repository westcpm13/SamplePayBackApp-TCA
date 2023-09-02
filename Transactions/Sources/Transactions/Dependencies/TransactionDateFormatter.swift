import Combine
import Foundation
import ComposableArchitecture

enum TransacionDateFormat {
    enum Input: String {
        case transactions = "yyyy-MM-dd'T'HH:mm:ssZ"
    }
    enum Output: String {
        case transactions = "yyyy-MM-dd HH:mm:ss"
    }
}

protocol TransacionDateFormating {
    @Sendable
    func getLocalizedDate(
        _ date: Date,
        format: TransacionDateFormat.Output,
        locale: Locale?
    ) -> String
    
    @Sendable
    func format(
        _ dateString: String?,
        format: TransacionDateFormat.Input,
        timeZone: TimeZone?
    ) -> Date?
}

struct TransacionDateFormatter: TransacionDateFormating {
    private let dateFormatter: DateFormatter

    init(dateFormatter: DateFormatter = DateFormatter()) {
        self.dateFormatter = dateFormatter
    }
    
    func format(
        _ dateString: String?,
        format: TransacionDateFormat.Input,
        timeZone: TimeZone?
    ) -> Date? {
        guard let dateString = dateString else { return nil }
        dateFormatter.dateFormat = format.rawValue
        dateFormatter.timeZone = timeZone ?? TimeZone(identifier: "UTC")
        return dateFormatter.date(from: dateString)
    }
    
    func getLocalizedDate(
        _ date: Date,
        format: TransacionDateFormat.Output,
        locale: Locale?
    ) -> String {
        dateFormatter.timeZone = .current
        dateFormatter.dateFormat = format.rawValue
        dateFormatter.locale = locale ?? Locale.current
        return dateFormatter.string(from: date)
    }
}

extension DependencyValues {
    var transacionDateFormatter: TransacionDateFormatter {
        get { self[TransacionDateFormatterKey.self] }
        set { self[TransacionDateFormatterKey.self] = newValue }
    }
    
    private enum TransacionDateFormatterKey: DependencyKey {
        static let liveValue = TransacionDateFormatter()
        static let testValue = TransacionDateFormatter()
    }
}
