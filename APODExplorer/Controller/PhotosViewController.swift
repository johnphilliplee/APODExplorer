import UIKit

class PhotosViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var apods = [APOD]()
    
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

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAPOD()
    }
    
    private func fetchAPOD() {
        let baseURL = "https://api.nasa.gov/planetary/apod"
        let url = URL(string: "\(baseURL)?api_key=\(apiKey)&count=21")!
        let urlRequest = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: urlRequest) {[weak self] data, response, error in
            guard let data = data else {
                return
            }
            
            do {
                let decoder = JSONDecoder()
                self?.apods = try decoder.decode([APOD].self, from: data)
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            } catch {
                print("Error occurred!")
            }
        }
        
        task.resume()
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { [weak self] context in
            self?.collectionView.collectionViewLayout.invalidateLayout()
            self?.collectionView.reloadData()
        }, completion: nil)
    }
}

extension PhotosViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        apods.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "APODCell", for: indexPath) as? APODCell else {
            fatalError()
        }
        
        cell.configure(with: apods[indexPath.item])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let isLandscape = collectionView.frame.size.width > collectionView.frame.size.height
        let numberOfColumns: CGFloat = isLandscape ? 5 : 3
        let cellWidth = collectionView.frame.size.width / numberOfColumns - 1
        
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        1
    }
}
