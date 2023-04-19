import Foundation
import UIKit

actor ImageLoader {
    enum ImageLoaderError: Error {
        case unableToDownloadImage
    }
    
    enum Status {
        case loading(Task<UIImage, Error>)
        case loaded(UIImage)
        case error(Error)
    }
    
    private var cache: [URL: Status] = [:]
    
    func image(for url: URL) async throws -> UIImage {
        if let value = cache[url] {
            switch value {
            case .loading(let task):
                return try await task.value
            case .loaded(let image):
                return image
            case .error(let error):
                throw error
            }
        }
        
        let downloadTask: Task<UIImage, Error> = Task.detached {
            let image = try await URLSession.shared.data(from: url).0
            if let image = UIImage(data: image) {
                return image
            }
            
            throw ImageLoaderError.unableToDownloadImage
        }
        
        cache[url] = .loading(downloadTask)
        
        do {
            let image = try await downloadTask.value
            add(image: image, forKey: url)
            return image
        } catch {
            cache[url] = .error(error)
            throw error
        }
    }
    
    private func add(image: UIImage, forKey key: URL) {
        cache[key] = .loaded(image)
    }
}
