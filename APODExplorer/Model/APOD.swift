import Foundation

struct APOD: Codable {
    let date: Date
    let title: String
    let url: String
    let explanation: String
}

extension APOD: Comparable {
    static func < (lhs: APOD, rhs: APOD) -> Bool {
        lhs.date < rhs.date
    }
}
