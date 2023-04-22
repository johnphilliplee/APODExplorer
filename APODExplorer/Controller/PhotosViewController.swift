import UIKit

class PhotosViewController: UIViewController {
    private enum State {
        case initial
        case loading
        case loaded
        case error(Error)
    }
    
    init(viewModel: APODViewModel, dataSource: PhotosViewControllerDataSource) {
        self.viewModel = viewModel
        self.dataSource = dataSource
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.viewModel = APODViewModel(apodService: NASAAPODService(networkService: APODNetworkService()))
        self.dataSource = PhotosViewControllerDataSource(viewModel: viewModel, imageLoader: imageLoader)

        super.init(coder: coder)
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    private let imageLoader = ImageLoader()
    private var viewModel: APODViewModel
    private var dataSource: PhotosViewControllerDataSource
    private var state: State = .initial {
        didSet {
            switch state {
            case .initial:
                activityIndicatorView.isHidden = true
                collectionView.isHidden = true
            case .loading:
                activityIndicatorView.startAnimating()
                activityIndicatorView.isHidden = false
                collectionView.isHidden = true
            case .loaded:
                activityIndicatorView.stopAnimating()
                activityIndicatorView.isHidden = true
                collectionView.isHidden = false
            case .error(_):
                // Show error UI here
                activityIndicatorView.isHidden = true
                collectionView.isHidden = true
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = dataSource
        collectionView.delegate = self
        
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
        let endDate = Date().addingTimeInterval(-(1 * 24 * 60 * 60))

        state = .loading
        viewModel.fetchAPODS(start: startDate, end: endDate) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success():
                    self?.state = .loaded
                    self?.collectionView.reloadData()
                case .failure(let error):
                    self?.state = .error(error)
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
    }
}

extension PhotosViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let apod = viewModel.apod(atIndex: indexPath.item) else {
            return
        }
                
        let detailViewController = PhotoDetailViewController(apod: apod, imageLoader: imageLoader)
        let navigationController = UINavigationController(rootViewController: detailViewController)
        navigationController.modalPresentationStyle = .fullScreen
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        UINavigationBar.appearance().standardAppearance = appearance
        
        present(navigationController, animated: true)
    }
}
