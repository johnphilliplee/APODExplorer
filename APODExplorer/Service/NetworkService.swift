import Foundation

protocol NetworkService {
    func request(endPoint: URL, completion: @escaping (Result<Data, Error>) -> Void)
}

class APODNetworkService: NetworkService {
    enum APODNetworkServiceError: Error {
        case nilData
        case unexpectedResponse
        case serverError(HTTPURLResponse)
    }
    
    func request(endPoint: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        let urlRequest = URLRequest(url: endPoint)
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard let data = data else {
                completion(.failure(APODNetworkServiceError.nilData))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(APODNetworkServiceError.unexpectedResponse))
                return
            }
            
            if (200...299).contains(httpResponse.statusCode) {
                completion(.success(data))
            } else {
                completion(.failure(APODNetworkServiceError.serverError(httpResponse)))
            }
        }
        
        task.resume()
    }
}
