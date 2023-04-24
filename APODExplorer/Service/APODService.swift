import Foundation
import UIKit

protocol APODService {
    func fetchAPODs(start: Date, end: Date, completion: @escaping (Result<[APOD], Error>) -> Void)
}

class NASAAPODService: APODService {
    enum NASAAPODService: Error {
        case invalidURL
    }
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    let networkService: NetworkService
    
    private var apiKey: String {
        guard let filePath = Bundle.main.path(forResource: "APOD-Info", ofType: "plist") else {
            fatalError("Couldn't locate 'APOD-Info.plist'")
        }
        
        let plist = NSDictionary(contentsOfFile: filePath)
        guard let value = plist?.object(forKey: "API_KEY") as? String else {
            fatalError("Couldn't find API_KEY in 'APOD-Info.plist'")
        }
        
        if value.starts(with: "_") {
            fatalError("Generate an API Key at https://api.nasa.gov and put it on APOD-Info.plist")
        }
        
        return value
    }
    
    func fetchAPODs(start: Date, end: Date, completion: @escaping (Result<[APOD], Error>) -> Void) {
        let endpoint: Endpoint = .apods(from: start, to: end, apiKey: apiKey)
                
        guard let url = endpoint.url else {
            completion(.failure(NASAAPODService.invalidURL))
            return
        }
        
        networkService.request(endPoint: url) { result in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    decoder.dateDecodingStrategy = .formatted(dateFormatter)
                    
                    let apods = try decoder.decode([APOD].self, from: data)
                    completion(.success(apods))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
