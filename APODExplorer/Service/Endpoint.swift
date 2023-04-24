import Foundation

struct Endpoint {
    enum Scheme: String {
        case http
        case https
    }
    
    private let scheme: Endpoint.Scheme
    private let host: String
    private let path: String?
    private var queryItems: [URLQueryItem]
    
    init(scheme: Endpoint.Scheme = .https,
                host: String,
                path: String? = nil,
                queryItems: [URLQueryItem] = []) {
        self.scheme = scheme
        self.host = host
        self.path = path
        self.queryItems = queryItems
    }
}

extension Endpoint {
    var url: URL? {
        var components = URLComponents()
        
        components.scheme = scheme.rawValue
        components.host = host
        addPathIfNecessary(components: &components)
        addQueryItemsIfNecessary(components: &components)
        
        return components.url
    }
    
    private func addPathIfNecessary(components: inout URLComponents) {
        guard let path = path else {
            return
        }
        components.path = path
    }

    private func addQueryItemsIfNecessary(components: inout URLComponents) {
        guard queryItems.count > 0 else {
            return
        }
        components.queryItems = queryItems
    }
}
