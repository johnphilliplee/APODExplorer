import Foundation

class APODViewModel {
    init(apodService: APODService) {
        self.apodService = apodService
    }
    
    private let apodService: APODService
    private var apods = [APOD]()
    
    func fetchAPODS(start: Date, end: Date, completion: @escaping (Result<Void, Error>) -> Void) {
        apodService.fetchAPODs(start: start, end: end) { [weak self] result in
            switch result {
            case .success(let apods):
                self?.apods = apods
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func numberOfSections() -> Int {
        1
    }
    
    func numberOfItemsInSection(_ section: Int) -> Int {
        apods.count
    }
    
    func apod(atIndex index: Int) -> APOD? {
        guard index >= 0, index < apods.count else {
            return nil
        }
        
        return apods[index]
    }
}
