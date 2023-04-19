import UIKit

class PhotosViewController: UIViewController {
    init(viewModel: APODViewModel, dataSource: PhotosViewControllerDataSource) {
        self.viewModel = viewModel
        self.dataSource = dataSource
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.viewModel = APODViewModel(apodService: NASAAPODService(networkService: APODNetworkService()))
        self.dataSource = PhotosViewControllerDataSource(viewModel: viewModel)

        super.init(coder: coder)
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var viewModel: APODViewModel
    private var dataSource: PhotosViewControllerDataSource
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = dataSource
        
        fetchData()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateCollectionViewLayout(forSize: collectionView.frame.size)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { [weak self] context in
            self?.updateCollectionViewLayout(forSize: size)
        }, completion: nil)
    }
    
    private func updateCollectionViewLayout(forSize size: CGSize) {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        layout.sectionInset = .zero
        
        let isLandscape = size.width > size.height
        let numberOfColumns: CGFloat = isLandscape ? 5 : 3
        let cellLength = collectionView.frame.size.width / numberOfColumns - 1
        layout.itemSize = CGSize(width: cellLength, height: cellLength)
        
        collectionView.collectionViewLayout = layout
    }

        
    private func fetchData() {
        let startDate = Date().addingTimeInterval(-(30 * 24 * 60 * 60))
        let endDate = Date()

        viewModel.fetchAPODS(start: startDate, end: endDate) { [weak self] result in
            switch result {
            case .success():
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}
