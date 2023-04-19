import Foundation
import UIKit

/// Demonstrating building UI via code
class PhotoDetailViewController: UIViewController {
    init(apod: APOD, imageLoader: ImageLoader) {
        self.apod = apod
        self.imageLoader = imageLoader
        
        super.init(nibName: nil, bundle: nil)
        
        let dismissButton = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(dismissDetailScreen))
        dismissButton.tintColor = .white
        navigationItem.rightBarButtonItem = dismissButton
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let apod: APOD
    private let imageLoader: ImageLoader
    private var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .gray
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
        
    private func setupUI() {
        view.backgroundColor = .gray
        view.addSubview(backgroundImageView)

        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: backgroundImageView.topAnchor),
            view.leadingAnchor.constraint(equalTo: backgroundImageView.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: backgroundImageView.bottomAnchor)
        ])
        
        // Set the image using the apod property
        if let imageURL = URL(string: apod.url) {
            backgroundImageView.load(url: imageURL, using: imageLoader)
        }
    }
    
    @objc
    private func dismissDetailScreen() {
        dismiss(animated: true)
    }
}