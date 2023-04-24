import Foundation

extension Endpoint {
    static func apods(from start: Date, to end: Date, apiKey: String) -> Endpoint {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let startDate = dateFormatter.string(from: start)
        let endDate = dateFormatter.string(from: end)
        
        return Endpoint(
            scheme: .https,
            host: "api.nasa.gov",
            path: "/planetary/apod",
            queryItems: [
                URLQueryItem(name: "api_key", value: apiKey),
                URLQueryItem(name: "start_date", value: startDate),
                URLQueryItem(name: "end_date", value: endDate)
            ]
        )
    }
}
